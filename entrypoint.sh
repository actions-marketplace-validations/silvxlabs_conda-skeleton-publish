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
find -name *.tar.bz2 | while read file
do
    echo $file
    for PLATFORM in "${INPUT_PLATFORMS[@]}"
    do
        conda convert --force --platform $PLATFORM $file -o .
    done
done

echo "Uploading to anaconda channel"
export ANACONDA_API_TOKEN=$INPUT_ACCESS_TOKEN
find . -name *.tar.bz2 | while read file
do
    echo $file
    anaconda upload --user $INPUT_UPLOAD_CHANNEL $file
done