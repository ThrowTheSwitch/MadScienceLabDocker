# Mad Science Lab C Unit Testing Docker Image
Cross-compilation C unit testing environment with Unity, CMock, and Ceedling.

## Contents
* Testing tools
  * [Ceedling](http://www.throwtheswitch.org/ceedling) 0.30.0
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

## Usage
`docker run -it --rm -v <local project path>:/project throwtheswitch/madsciencelab[:tag]`

