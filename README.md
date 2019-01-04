# Mad Science Lab C Unit Testing Docker Image
Cross-compilation C unit testing environment with Unity, CMock, and Ceedling.

## Contents
* Testing tools
  * Ceedling 0.28.3
  * CMock 2.4.5
  * Unity 2.4.2
* C support
  * CException 1.3.1
  * [libc-dev 0.7.1](https://pkgs.alpinelinux.org/package/v3.8/main/x86/libc-dev)
* Environment
  * [coreutils 8.29](https://pkgs.alpinelinux.org/package/v3.8/main/x86/coreutils)
  * gcc 6.4.0
  * gcov 6.4.0
  * valgrind 3.13.0
  * Ruby 2.4.5

## Usage
`docker run -it --rm -v <local project path>:/project throwtheswitch/madsciencelab[:tag]`

