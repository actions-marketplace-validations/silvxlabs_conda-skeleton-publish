#!/bin/bash
echo "\n\n======================================="
echo "Creating build recipe from PyPI package"
echo "=======================================\n\n"
conda skeleton pypi $INPUT_PYPI_PACKAGE

echo "\n\n======================"
echo "Building conda package"
echo "======================\n\n"
for CHANNEL in $INPUT_BUILD_CHANNELS
do
    conda config --append channels $CHANNEL
done

cd $INPUT_PYPI_PACKAGE
conda mambabuild --python $INPUT_PYTHON_VERSION --output-folder . .
rm -r noarch

echo "\n\n============================="
echo "Converting to other platforms"
echo "=============================\n\n"
conda convert --force --platform all linux-64/*.tar.bz2 -o .

echo "\n\n============================="
echo "Uploading to anaconda channel"
echo "=============================\n\n"
export ANACONDA_API_TOKEN=$INPUT_ACCESS_TOKEN
for PLATFORM in $INPUT_PLATFORMS
do
    echo $PLATFORM
    anaconda upload --user $INPUT_UPLOAD_CHANNEL $PLATFORM/*.tar.bz2
done
