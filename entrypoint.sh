#!/bin/bash
echo "Creating build recipe from PyPI package"
conda skeleton pypi $INPUT_PYPI_PACKAGE

echo "Building conda package"
for CHANNEL in "${INPUT_BUILD_CHANNELS[@]}"
do
    conda config --append channels $CHANNEL
done

cd $INPUT_PYPI_PACKAGE
conda build --python $INPUT_PYTHON_VERSION --output-folder . .

echo "Converting to other platforms"
find -name *.tar.bz2 | while read file
do
    echo $file
    for PLATFORM in "${INPUT_PLATFORMS[@]}"
    do
        if ["noarch" != $PLATFORM]; then
          conda convert --force --platform $PLATFORM $file -o .
        fi
    done
done

echo "Uploading to anaconda channel"
export ANACONDA_API_TOKEN=$INPUT_ANACONDA_TOKEN
find . -name *.tar.bz2 | while read file
do
    echo $file
    anaconda upload --user $INPUT_UPLOAD_CHANNEL $file
done