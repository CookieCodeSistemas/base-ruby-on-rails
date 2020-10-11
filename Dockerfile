FROM ruby:2.7.2
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
MAINTAINER CookieCode <contact@cookiecode.com.br>

ENV APP=/var/www
ENV HOME=/home/devel

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    openssh-server \
    sudo \
    cmake \
    locales \
    graphviz \
    htop \
    libpq-dev

# skip installing gem documentation
RUN chmod 777 /usr/local/bundle && mkdir -p /usr/local/etc && { echo 'install: --no-document'; echo 'update: --no-document'; } >> /usr/local/etc/gemrc

RUN adduser --disabled-password --gecos '' devel \
  && usermod -a -G sudo devel \
  && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
  && echo 'devel:devel' | chpasswd

RUN mkdir -p $HOME \
    && mkdir -p $APP \
    && chown -R devel:devel $HOME \
    && chown -R devel:devel $APP

USER devel:devel
WORKDIR $APP


# GEM
RUN echo "gem: --no-document" > ~/.gemrc
RUN gem install bundler

# RAILS
RUN gem update --system \
  && gem install bundler \
  && gem install rails

# Expose ports.
EXPOSE 3000

CMD /bin/bash
