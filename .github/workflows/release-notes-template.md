# MadScienceLab Docker Images Builds

Each build produces multiple variants of the `throwtheswitch/madsciencelab` Docker images containing [Ceedling](https://github.com/ThrowTheSwitch/Ceedling) and its supporting frameworks as well as various utilities and compilation toolchains. Each image built from this repository targets multiple runtime host platforms.

Build types (via Github Actions):

1. Any push or pull request generates and validates the Dockerfiles for each image variant (lint + structural check), without building a real image.
1. A pre-release tag adds to (1) by performing a real multi-platform Docker image build (not pushed to Docker Hub) and publishing a GitHub pre-release.
1. A release tag adds to (2) by pushing the resulting Docker images to Docker Hub.

See the [Docker Hub repository](https://hub.docker.com/r/throwtheswitch) for official releases of the resulting Docker images and their documentation.

Versioning of this repository and the resulting tags in Docker Hub tracks Ceedling’s version. Docker image changes are maintained with a lowercase letter suffix appended to the version of Ceedling contained in each image itself.

# Build Artifacts

* A zip archive for each Docker image containing the generated Dockerfile and any other generated file artifacts used to build the image in Docker Hub.
* A zip archive of the entire project including the static assets used to build the Docker images.

See this repository’s documentation for instructions on how to use the tools of this repository and how to manually build the Docker images this repository maintains.

# Changelog
