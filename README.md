# Mad Science Lab C Unit Testing & Build Environment Docker Images

C unit testing & release build environment with Unity, CMock, and Ceedling.
The Docker images produced from this repository contain everything needed for running unit tests and release builds with Ceedling and its supporting frameworks.

<!-- ## Contents
* Testing tools
  * [Ceedling](http://www.throwtheswitch.org/ceedling) 0.31.0
  * [CMock](http://www.throwtheswitch.org/cmock) 2.5.2
  * [Unity](http://www.throwtheswitch.org/unity) 2.5.1
* C support
  * [CException](http://www.throwtheswitch.org/cexception) 1.3.2
  * [libc-dev 0.7.2](https://pkgs.alpinelinux.org/package/v3.11/main/x86/libc-dev)
* Environment
  * [coreutils 8.31](https://pkgs.alpinelinux.org/package/v3.11/main/x86/coreutils)
  * gcc 9.2.0
  * gcov 9.2.0
  * valgrind 3.15.0
  * Ruby 2.7.1
 -->
## Usage

### Generating Dockerfiles

`./build.sh --dir build/standard --variant "" --version 1.0.0`

`./build.sh --dir build/standard --dir build/plugins --version 1.0.0`

`./build.sh --dir build/arm-none-eabi --version 1.0.0`

`./build.sh --dir build/arm-none-eabi --dir build/plugins --dir build/arm-none-eabi-plugins --version 1.0.0`


## Basic Articles Discussing Unit Testing
  * This docker image uses Ceedling to build “native” code as described [here](http://www.throwtheswitch.org/build/which)
  * For additional help and tips for building native tests, read [this](http://www.throwtheswitch.org/build/native)