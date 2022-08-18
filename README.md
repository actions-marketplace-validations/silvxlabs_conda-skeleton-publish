# Conda Skeleton Publish

Generate a Conda build recipe from a PyPI package and publish to an Anaconda channel

## Inputs

-  `pypi_package`* : _Name of PyPI package to build_
-  `python_version`* : _Python version to build package for_
-  `package_version` : _PyPi package version to build_
-  `upload_channel`* : _Conda channel where the package will be uploaded_
-  `access_token`* : _Anaconda access token with read and write API permissions_
-  `build_channels`: _Space separated string of conda channels to use during the build. Defaults to `conda-forge`_
- `platforms`: _Space separated string of platforms to build. Defaults to `"win-64 osx-64 osx-arm64 linux-64 linux-aarch64"`_
-  `stable`* : _Set this to true if this is a stable release. Passes a `-l beta` arg if false. Defaults to false._
-  `wait` : _If true, waits for the PyPi package to become available. Defaults to false._

> `*` denotes required inputs

## Example usage

```YAML
on: workflow_dispatch

jobs:
  test:
    runs-on: ubuntu-latest
    name: Conda skeleton publish
    steps:
      - name: Publish conda package from PyPI package
        uses: actions/conda-skeleton-publish@v1
        with:
          pypi_package: "driptorch"
          python_version: "3.10"
          upload_channel: "holtz"
          access_token: ${{ secrets.ANACONDA_TOKEN }}
          stable: true
```
