FROM ruby:3.0.4-alpine3.16

RUN apk update \
    apk upgrade

RUN apk --no-cache add \
  coreutils \
  gcc \
  gcovr \
  valgrind \
  libc-dev

##
## Copy assets for inclusion in image
##
## Notes:
## - Gems must be downloaded manually to the vendored assets/gems directory.
## - To find the list of gems and versions needed, visit
##     https://rubygems.org/gems/ceedling/versions/0.31.0/dependencies
## - The easiest way to vendor a gem is `gem fetch <name> -v <version>` in assets/gems.
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


RUN mkdir /project

##
## Add base project path to $PATH (for help scripts, etc.)
##

ENV PATH "/project:$PATH"


##
## Programming environment setup
##

# Create empty project directory (to be mapped by source code volume)
WORKDIR /project

# When the container launches, run a shell that launches in WORKDIR
CMD ["/bin/sh"]
