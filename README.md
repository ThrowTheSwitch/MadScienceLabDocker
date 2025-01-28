# Unit Test Skeleton Example
The unit tests are configured in the CAN_App to execute using the ceedling gem script. This docker container has all the tools needed to run ceedling. If you do not have Docker Desktop installed you can install the tools locally on your PC or in a VM. The root folder contains InstallingCeedlingUnitTestTools.pdf which has instructions that I've summarized for installing the tools on your PC. A restart is usually required to finish the GCC install.
To run the tests, open Command Promp, navigate to the CAN_App folder, and execute ceedling. If everything is installed correctly you will see the following messages.
Test 'test_CAN.c'
-----------------
Running test_CAN.out...


Test 'test_CAN_Driver.c'
------------------------
Running test_CAN_Driver.out...

--------------------
IGNORED TEST SUMMARY
--------------------
[test_CAN_Driver.c]
  Test: test_CAN_Driver_NeedToImplement
  At line (17): "Need to Implement CAN_Driver"

--------------------
OVERALL TEST SUMMARY
--------------------
TESTED:  3
PASSED:  2
FAILED:  0
IGNORED: 1

# Mad Science Lab C Unit Testing Docker Image

C unit testing environment with Unity, CMock, and Ceedling. The purpose of this Docker
image is to create an easy-to-install portable system for running unit tests with Ceedling.

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


Alternatively, if you do not have docker installed, follw the instructions in InstallingCeedlingUnitTestTools.pdf to install the tools locally.

## Basic Articles Discussing Unit Testing
  * This docker image uses Ceedling to build "native" code as described [here](http://www.throwtheswitch.org/build/which)
  * For additional help and tips for building native tests, read [this](http://www.throwtheswitch.org/build/native)