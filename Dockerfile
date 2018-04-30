FROM ubuntu:xenial
MAINTAINER Jack Willis-Craig <jackw@fishvision.com>
ENV DEBIAN_FRONTEND noninteractive

# Remove sh
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Install packages
RUN apt update
RUN apt -y install wget \
    curl \
    git \
    zip \
    unzip \
    libxml2-dev \
    build-essential \
    software-properties-common \
    libssl-dev \
    python \
    python-dev \
    python-pip \
    python-virtualenv \
    vim \
    jq \
    coreutils \
    openssh-client \
    apt-transport-https \
    libelf1 # Required by flow-bin
    
RUN curl -o- https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# Install google cloud sdk
RUN curl -fsSL https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-155.0.0-linux-x86_64.tar.gz -o /google-cloud-sdk.tar.gz
RUN tar -xf /google-cloud-sdk.tar.gz -C /
RUN /google-cloud-sdk/install.sh --usage-reporting false --path-update true
RUN rm /google-cloud-sdk.tar.gz
RUN ln -s /google-cloud-sdk/bin/gcloud /usr/bin/

# Install awscli
RUN pip install awscli

# Install node
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.5/install.sh | bash && \
    export NVM_DIR="/root/.nvm" && \
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" && \
    nvm install 8 --lts && \
    npm update npm -g

# Install yarn
RUN apt update && apt -y install yarn --no-install-recommends

# Clean apt
RUN apt clean

# Misc
RUN mkdir -p ~/.ssh
RUN [[ -f /.dockerenv ]] && echo -e "Host *\n\tStrictHostKeyChecking no\n\n" > ~/.ssh/config
