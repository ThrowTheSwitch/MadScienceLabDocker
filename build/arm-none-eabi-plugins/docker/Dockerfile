## Base Docker Image
## minideb is a slim Debian base image well maintained by VMWare
## https://github.com/bitnami/minideb
FROM bitnami/minideb:bookworm

# This image is meant to include multi-platform support via Docker's buildx/BuildKit client and service. 
# In recent versions of Docker desktop `docker build` uses the buildx client by default. Under such a build,
# the build argument TARGETPLATFORM is set automatically.
#
# If this image is built without buildx/BuildKit, the build argument below must be set from the command line. 
# The command line must include `--build-arg TARGETPLATFORM=<platform>` where platform is a Docker-
# recognized platform string (e.g. "linux/amd64").
ARG TARGETPLATFORM

# This build argument allows setting the image tag at build time to support CI-based builds
# The command line must include `--build-arg CONTAINER_VERSION=<version>`
ARG CONTAINER_VERSION

# Capture TARGETPLATFORM as an environment variable in the image
ENV CONTAINER_PLATFORM=$TARGETPLATFORM

# Docker image tag for internal container use, set via Docker build argument
ENV MADSCIENCELAB_VERSION=$CONTAINER_VERSION

##
## Docker Image Best Practices
## https://docs.docker.com/develop/develop-images/instructions/
##

## Metadata
LABEL org.opencontainers.image.source=https://github.com/ThrowTheSwitch/MadScienceLabDocker
LABEL org.opencontainers.image.url=https://github.com/ThrowTheSwitch/MadScienceLabDocker/blob/master/README.md
LABEL org.opencontainers.image.base.name=docker.io/bitnami/minideb
LABEL org.opencontainers.image.title="Mad Science Lab"
LABEL org.opencontainers.image.description="Contains Ceedling, supporting frameworks, and GNU C toolchain to provide a unit testing and build system environment for C projects"

# Image base / set up
RUN set -ex \
  # Update package management environment
  && apt update \
  && apt -y upgrade \
  && apt install -y \
     coreutils \
     gcc-arm-none-eabi \
     gcovr \
     git-all \
     libnewlib-arm-none-eabi \
     locales \
     nano \
     ncurses-bin \
     ruby=1:3.1 \
     subversion \
     unzip \
     valgrind \
     zsh \
     --no-install-recommends \
  && apt autoremove \
  && apt clean \
  && rm -rf /var/lib/apt/lists/*

##
## Locale setting for Ruby encoding handling
##
## https://stackoverflow.com/questions/17031651/rails-invalid-byte-sequence-in-us-ascii-argument-error-when-i-run-rake-dbsee
## https://www.graalvm.org/latest/reference-manual/ruby/UTF8Locale/
##

# Set environment variables
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# Run Debian locale setting operation
RUN set -ex \
  # Uncomment the en_US.UTF-8 line in /etc/locale.gen
  && sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen \
  # locale-gen generates locales for all uncommented locales in /etc/locale.gen
  && locale-gen

##
## Copy Ruby assets for inclusion in image
##
## Notes:
## - Gems must be downloaded manually to the vendored bse/assets/gems directory.
## - To find the list of gems and versions needed, visit
##     https://rubygems.org/gems/ceedling/versions/<version>/dependencies
## - The easiest way to vendor a gem is `gem fetch <name> -v <version>` with volume mapped to assets/gems.
##
COPY build/base/assets /assets/base 

##
## Copy Dotnet assets for temporary use
##
## Notes:
## - The Microsoft Debian package sources file is needed to install Dotnet
## - The file should be downloaded and vendored to assets/
##   wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
##
COPY build/plugins/assets /assets/plugins 

# Copy generated shell welcome file into image
COPY build/arm-none-eabi-plugins/assets/shell/welcome /assets/arm-none-eabi-plugins/shell/welcome


# Install Ceedling, CMock, Unity, CException + gem dependencies
RUN set -ex \
  # Prevent documentation installation taking up space
  echo -e "---\ngem: --no-ri --no-rdoc\n...\n" > .gemrc \
  # Install Ceedling and related gems
  && gem install --force --local /assets/base/gems/*.gem \
  && gem install bundler \
  && bundle install --gemfile=/assets/base/gems/Gemfile \
  && rm .gemrc 

# Microsoft Dotnet installation to support `reportgenerator` for `gcov` plugin
# Only available on AMD64 image builds
RUN if [[ $TARGETPLATFORM == "linux/amd64" ]] ; then set -ex \
   && dpkg -i /assets/plugins/dotnet/packages-microsoft-prod.deb \
   && apt update \
   && apt install -y \
      dotnet-sdk-8.0 \
      --no-install-recommends \
   && apt clean \
   && rm -rf /var/lib/apt/lists/* ; fi 


##
## Permissions Security & Cleanup
## - After necessary installations, etc. as root user ensure default container user is not root
## - Create user `dev` (with group 999) and make `dev` the default user
## - Delete /assets directory
##

RUN set -ex \
  && groupadd -r nonroot --gid 999 \
  && useradd -s /usr/bin/zsh -r -g nonroot dev

# Set up new user home directory and cleanup /assets
RUN set -ex \
  # Give the new user home directory +rwx permissions to group members
  # This will allow us to dynamically specify the host user for the container but give them group permissions
  && mkdir -p /home/dev \
  && chown dev:nonroot /home/dev \
  && chmod -R ug+rwx /home/dev \
  # Copy simple Z shell config file & give new user permissions
  && cp /assets/base/shell/zshrc /home/dev/.zshrc \
  && chown dev:nonroot /home/dev/.zshrc \
  # Copy welcome file & give new user permissions
  && cp /assets/arm-none-eabi-plugins/shell/welcome /home/dev/.welcome \
  && chown dev:nonroot /home/dev/.welcome \
  # Cleanup assets
  && rm -rf /assets

# Become / set new user
USER dev

# Install `reportgenerator` (for `gcov` plugin)
# Only available in AMD64 containers
RUN if [[ $TARGETPLATFORM == "linux/amd64" ]] ; then set -ex \
  # Install the dotnet tool as global (which means global for the current user vs. a local directory)
  && dotnet tool install --global dotnet-reportgenerator-globaltool \
  # Modify the PATH so the new tool is findable
  && echo "[[ -d \"$HOME/.dotnet/tools\" ]] && export PATH=\"$PATH:$HOME/.dotnet/tools\"" >> $HOME/.zshenv ; fi 


WORKDIR /home/dev/project

# When the container launches, run a shell that launches in WORKDIR
CMD ["/usr/bin/zsh"]

