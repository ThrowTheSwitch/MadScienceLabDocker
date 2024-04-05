## Base Docker Image
## minideb is a slim Debian base image maintained by VMWare
FROM bitnami/minideb:bookworm-amd64

##
## Docker Image Best Practices
## https://docs.docker.com/develop/develop-images/instructions/
##

# Image base / set up
RUN set -ex \
  # Update package management environment
  && apt update \
  && apt -y upgrade \
  && apt install -y \
     build-essential \
     coreutils \
     gcc \
     gdb \
     libc-dev \
     nano \
     ruby=1:3.1 \
     zsh \
     --no-install-recommends \
  && apt clean \
  && rm -rf /var/lib/apt/lists/*

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


# Install Ceedling, CMock, Unity, CException + gem dependencies
RUN set -ex \
  # Prevent documentation installation taking up space
  echo -e "---\ngem: --no-ri --no-rdoc\n...\n" > .gemrc \
  # Install Ceedling and related gems
  && gem install --force --local /assets/base/gems/*.gem \
  && rm .gemrc 


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
  && cp /assets/base/shell/welcome /home/dev/.welcome \
  && chown dev:nonroot /home/dev/.welcome \ 
  # Cleanup assets
  && rm -rf /assets

# Become / set new user
USER dev


WORKDIR /home/dev/project

# When the container launches, run a shell that launches in WORKDIR
CMD ["/usr/bin/zsh"]

