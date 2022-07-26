#!/bin/bash

echo "======================================="
echo "Creating build recipe from PyPI package"
echo "======================================="
conda skeleton pypi $INPUT_PYPI_PACKAGE

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
    anaconda upload --user $INPUT_UPLOAD_CHANNEL $PLATFORM/*.tar.bz2
done
