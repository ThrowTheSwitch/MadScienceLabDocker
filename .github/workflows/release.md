## MadScienceLab Docker Images Builds

Each build produces multiple variants of the `madsciencelab` Docker images containing Ceedling and its supporting frameworks as well as various utilities and compilation toolchains. Each image targets multiple host platforms.

A dev build of this repository in a Github Action generates files and validates the Docker image build. A release build also pushes the resulting Docker images to Docker hub.

See the [Docker Hub repository](https://hub.docker.com/r/throwtheswitch) for official releases of the resulting Docker images and their documentation.

## Contents

* A zip archive for each Docker image containing the generated Dockerfile and any other generated file artifacts used to build the image in Docker Hub.
* A zip archive of the entire project including the static assets used to build the Docker images.

See this reository’s documentation for instructions on how to use the tools of this repository and how to build these Docker images.