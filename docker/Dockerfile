# Dockerfile
FROM arthurliang/debian:jessie-slim

ADD ./*.sh /minimeteor/

# Install build tools
RUN apt-get -qq update && DEBIAN_FRONTEND=noninteractive apt-get -y install \
      curl \
      procps \
      python \
      g++ \
      make \
      sudo \
      git \
      bzip2 \
      rsync

# install Meteor
RUN sudo -u user curl -sL "https://install.meteor.com/" | sed s/--progress-bar/-sL/g | sh


# We call the "meteor" command for the first time which will install the Meteor binaries in ~/.meteor.
RUN sudo -u user meteor --help

ONBUILD ARG NPM_TOKEN
ONBUILD ADD . /app
ONBUILD WORKDIR /app
ONBUILD ENV DEBIAN_FRONTEND noninteractive
ONBUILD RUN /minimeteor/onbuild.sh
ONBUILD ENV PORT 3000
ONBUILD EXPOSE 3000
ONBUILD USER user
ONBUILD CMD cd /home/user/meteor-app/bundle/programs/server/ && ./node boot.js program.json

CMD /minimeteor/onrun.sh
