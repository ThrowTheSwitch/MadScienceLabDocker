# 🧪 Mad Science Lab C Unit Testing & Build Environment Docker Images

Self-contained C unit testing & release build environment with [Ceedling], [Unity], [CMock] and supporting tools.

## Overview & contents

The Docker images produced from this repository contain everything needed for running unit tests and release builds with [Ceedling] and its supporting frameworks.

This repository contains custom tooling, templates, and the assets necessary to produce multiple variations of the _MadScienceLab_ Docker images targeting different toolchains and containing various collections of supporting tools. A Github Action builds the images and publishes them to Docker Hub.

* [Docker Hub _MadScienceLab_ images][hub-images].
* See this [repository’s releases][releases] for the versioned Dockerfiles produced by the Github Action builds.

The basic idea of this repository is to generate Dockerfiles rather than only maintain the text of one or more Dockerfiles. A custom Ruby-based command line tool uses a template and conventions for directories and files to build up Dockerfiles. This approach has a couple benefits:

1. In this way, common base elements can be easily maintained across multiple Dockerfiles.
1. Entirely new — potentially proprietary — Dockerfiles can be generated as extensions of the _MadScienceLab_ images with elements maintained outside of this repository.

## Supporting this work

These Docker images and complementary [ThrowTheSwitch] pieces and parts are and always will be freely available and open source.

💼 **_[Ceedling Suite][ceedling-suite]_** is a growing collection of paid products and services built around Ceedling to help you do even more. **_[Ceedling Assist][ceedling-assist]_** for support contracts and training is now available.

🙏🏻 **[Please consider supporting Ceedling as a Github Sponsor][tts-sponsor]**

[Ceedling]: https://github.com/ThrowTheSwitch/Ceedling
[Unity]: https://github.com/ThrowTheSwitch/Unity
[CMock]: https://github.com/ThrowTheSwitch/CMock

[hub-images]: https://hub.docker.com/r/throwtheswitch
[releases]: https://github.com/ThrowTheSwitch/MadScienceLabDocker/releases

[ThrowTheSwitch]: https://github.com/ThrowTheSwitch
[ceedling-suite]: https://www.thingamabyte.com/ceedling
[ceedling-assist]: https://www.thingamabyte.com/ceedlingassist
[tts-sponsor]: https://github.com/sponsors/ThrowTheSwitch

# 🏭 Usage

_January, 2025_: More complete documentation on working with the contents of this repository is forthcoming. This repository underwent significant changes in step with the 1.0.0 release of Ceedling.

## Generating Dockerfiles

To generate the four Dockerfiles and related artifacts managed by this project from a local clone of this repository, install all Ruby dependencies using the Gemfile in the root of the project and execute the build shell script also in the root of the repository:

Examples:

* `./build.sh --dir build/standard --variant "" --version <tag>`
* `./build.sh --dir build/standard --dir build/plugins --version <tag>`
* `./build.sh --dir build/arm-none-eabi --version 1.0.0`
* `./build.sh --dir build/arm-none-eabi --dir build/plugins --dir build/arm-none-eabi-plugins --version <tag>`

The Github Action maintained in this repository uses the same approach as the preceding to generate the Dockerfiles attached to releases. The Github Action goes on to build images from those Dockerfiles and pushes them to Docker Hub.

## Ruby tool & shell script

The Ruby tool maintained in this repository does all of the Dockerfile text generation.

The shell script that calls the Ruby tool includes many options useful to a developer working on this repostory or anyone working to extend the Dockerfiles created by the tooling. Run `./build.sh -h` for a listing of the various options.

# 🔢 Versioning

Versioning of this repository and the resulting tags in Docker Hub track [Ceedling]’s version. Docker image changes are maintained with a lowercase letter suffix appended to the version of Ceedling contained in each _MadScienceLab_ image itself.

# 🔒 Security

Security documentation is maintained in the [Docker Hub image repositories][hub-images].

# 👩‍🏫 Intro to Unit Testing Supported by the MadScienceLab containers

* The “stock” Docker images maintained by this repository use Ceedling to build “native” code as described [here][which-build]. For additional help and tips for building native tests, read [this](native-tests).
* Advanced users of Ceedling also have the option of creating cross-compiled ARM test executable binaries with the `arm-none-eabi` Docker image variants. These binaries could be native tests on a target platform, or you could run them with a simulator test fixture on a host system. Read more about the simulator option [here][which-build] and how to work with it [here][simulator-tests].

[which-build]: http://www.throwtheswitch.org/build/which
[native-tests]: http://www.throwtheswitch.org/build/native
[simulator-tests]: https://www.throwtheswitch.org/build/cross

# 📄 License(s)

* The base image, [`minideb`][minideb], for the _MadScienceLab_ variants is [Apache 2.0][apache-20] licensed.
* The _ThrowTheSwitch_ work layered on top of `minideb` is [MIT] licensed (the license file is maintained in the root of this repository).

[minideb]: https://hub.docker.com/r/bitnami/minideb
[apache-20]: https://www.apache.org/licenses/LICENSE-2.0
[MIT]: https://opensource.org/license/mit