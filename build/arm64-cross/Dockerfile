## Base Docker Image
FROM throwtheswitch/madsciencelab:4.0-base-amd64-native

##
## Docker Image Best Practices
## https://docs.docker.com/develop/develop-images/instructions/
##

MAINTAINER Michael Karlesky <michael@karlesky.net>

# Update package management environment.
# - Add ARM development toolchain
RUN set -ex                       \
  && apt update                   \
  && apt -y upgrade               \
  && apt install -y               \
     gcc-arm-none-eabi            \
     libnewlib-arm-none-eabi      \
     --no-install-recommends      \
  && rm -rf /var/lib/apt/lists/*


USER dev
WORKDIR /home/dev/project/

