#!/bin/bash
echo "Creating build recipe from PyPI package"
conda skeleton pypi $INPUT_PYPI_PACKAGE

echo "Building conda package"
for CHANNEL in "${INPUT_BUILD_CHANNELS[@]}"
do
    conda config --append channels $CHANNEL
done

cd $INPUT_PYPI_PACKAGE
conda mambabuild --python $INPUT_PYTHON_VERSION --output-folder . .
rm -r noarch

echo "Converting to other platforms"
conda convert --force --platform all linux-64/*.tar.bz2 -o .

echo "Uploading to anaconda channel"
export ANACONDA_API_TOKEN=$INPUT_ACCESS_TOKEN
for PLATFORM in "${INPUT_PLATFORMS[@]}"
do
    echo $PLATFORM
    anaconda upload --user $INPUT_UPLOAD_CHANNEL $PLATFORM/*.tar.bz2
done
