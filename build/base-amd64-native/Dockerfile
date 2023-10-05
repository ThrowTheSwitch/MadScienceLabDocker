## Base Docker Image
## minideb is a slim Debian base image maintained by VMWare
FROM bitnami/minideb:bookworm-amd64

##
## Docker Image Best Practices
## https://docs.docker.com/develop/develop-images/instructions/
##

MAINTAINER Michael Karlesky <michael@karlesky.net>

# Update package management environment.
# - Add nano, a convenient text editor, in part to validate package management early in build
# - Add Zsh as shell environment
# - Add common C development packages
RUN set -ex                       \
  && apt update                   \
  && apt -y upgrade               \
  && apt install -y               \
     nano                         \
     zsh                          \
     coreutils                    \
     gcc                          \
     gcovr                        \
     valgrind                     \
     libc-dev                     \
     build-essential              \
     gdb                          \
     ruby=1:3.1                   \
     --no-install-recommends      \
  && rm -rf /var/lib/apt/lists/*

##
## Copy Ruby assets for inclusion in image
##
## Notes:
## - Gems must be downloaded manually to the vendored assets/gems directory.
## - To find the list of gems and versions needed, visit
##     https://rubygems.org/gems/ceedling/versions/0.31.0/dependencies
## - The easiest way to vendor a gem is `gem fetch <name> -v <version>` with volume mapped to assets/gems.
##

COPY assets/gems /assets/gems

# Install Ceedling, CMock, Unity
RUN set -ex \
  # Prevent documentation installation taking up space
  echo -e "---\ngem: --no-ri --no-rdoc\n...\n" > .gemrc \
  # Install Ceedling and related gems
  && gem install --force --local /assets/gems/*.gem \
  # Cleanup
  && rm -rf /assets \
  && rm .gemrc


##
## Permissions Security
## - After necessary installations, etc. as root user ensure default container user is not root
## - Create user dev (with group 999) and make dev the default user
##

RUN set -ex \
  && groupadd -r nonroot --gid 999 \
  && useradd -s /usr/bin/zsh -r -g nonroot dev

# Copy simple z shell config file
COPY --chown=dev:nonroot assets/shell/zshrc /home/dev/.zshrc

# Give the new user home directory +rwx permissions to group members
# This will allow us to dynamically specify the host user for the container but give them group permissions
RUN chmod -R ug+rwx /home/dev



# When the container launches, run a shell that launches in WORKDIR
CMD ["/usr/bin/zsh"]
