## MadScienceLab Docker Images Builds

Each build produces multiple variants of the `throwtheswitch/madsciencelab` Docker images containing Ceedling and its supporting frameworks as well as various utilities and compilation toolchains. Each image built from this repository targets multiple runtime host platforms.

Build types (via Github Actions):

1. A dev build of this repository generates files and validates the Docker image build.
1. A release build adds to (1) by also pushing the resulting Docker images to Docker Hub.

See the [Docker Hub repository](https://hub.docker.com/r/throwtheswitch) for official releases of the resulting Docker images and their documentation.

## Build Artifacts

* A zip archive for each Docker image containing the generated Dockerfile and any other generated file artifacts used to build the image in Docker Hub.
* A zip archive of the entire project including the static assets used to build the Docker images.

See this reository’s documentation for instructions on how to use the tools of this repository and how to manually build the Docker images this repository maintains.

## Changelog

### Added

* ...

### Fixed

* ...

### Changed

* ...

### Removed

* ...


