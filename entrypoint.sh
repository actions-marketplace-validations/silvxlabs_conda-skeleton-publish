#!/bin/bash

echo "======================================="
echo "Creating build recipe from PyPI package"
echo "======================================="
if [ $INPUT_PACKAGE_VERSION == 'latest' ] ; then
  conda skeleton pypi $INPUT_PYPI_PACKAGE
else
  echo $INPUT_PACKAGE_VERSION
  pypi_status=$(getconf ARG_MAX)
  while [ $pypi_status -gt 0 ] ; do
    conda skeleton pypi $INPUT_PYPI_PACKAGE --version $INPUT_PACKAGE_VERSION
    pypi_status=$?
    if [ $INPUT_WAIT == 'true' ] && [ $pypi_status -gt 0 ] ; then
      echo "Waiting for $INPUT_PYPI_PACKAGE $INPUT_PACKAGE_VERSION to be available from PyPi."
      sleep 10
    elif [ $pypi_status -gt 0 ] ; then
      exit $pypi_status
    fi
  done
fi


echo "======================"
echo "Building conda package"
echo "======================"
for CHANNEL in $INPUT_BUILD_CHANNELS
do
    conda config --append channels $CHANNEL
done

cd $INPUT_PYPI_PACKAGE
conda mambabuild --python $INPUT_PYTHON_VERSION --output-folder . .
rm -r noarch

echo "============================="
echo "Converting to other platforms"
echo "============================="
conda convert --force --platform all linux-64/*.tar.bz2 -o .

echo "============================="
echo "Uploading to anaconda channel"
echo "============================="
export ANACONDA_API_TOKEN=$INPUT_ACCESS_TOKEN
for PLATFORM in $INPUT_PLATFORMS
do
    echo $PLATFORM
    if [ $INPUT_STABLE == 'true' ] ; then
      echo "Stable release"
      anaconda upload --user $INPUT_UPLOAD_CHANNEL --skip-existing $PLATFORM/*.tar.bz2
    else
      echo "Beta release"
      anaconda upload --user $INPUT_UPLOAD_CHANNEL -l beta --skip-existing $PLATFORM/*.tar.bz2
    fi
done
