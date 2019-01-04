FROM ruby:2.4.5-alpine3.8

MAINTAINER Michael Karlesky <michael@karlesky.net>


RUN apk --no-cache add \
	coreutils \
	gcc \
  gcovr \
  valgrind \
	libc-dev

##
## Copy assets for inclusion in image
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
