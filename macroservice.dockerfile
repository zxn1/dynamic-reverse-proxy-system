# base image
FROM php:8.0-apache

# install for SSH things first
# and also update system packages && install system dependencies
RUN apt-get update && apt-get install -y \
    libonig-dev \
    libzip-dev \
    unzip \
    openssh-server \
    netcat \
    build-essential \
    libssl-dev

# create privilege separation directory
RUN mkdir /run/sshd

# configure SSH server
RUN echo "GatewayPorts yes" >> /etc/ssh/sshd_config

# generate SSH host keys
RUN ssh-keygen -A

# add user test as SSH user
RUN useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo -u 1000 test 

# set test user's password as 'test'
RUN  echo 'test:test' | chpasswd

# public directory
WORKDIR /var/www/html

# create directory for lumen
RUN mkdir lumen

# working directory
WORKDIR /var/www/html/lumen

# copy file into container
COPY compose/lumen/. .

# install curl
RUN apt install -y \
    curl

# install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# copy and change the .env name
COPY setup/microapi.env.example .
RUN mv microapi.env.example .env

# Install Laravel dependencies
RUN composer install --ignore-platform-reqs

# set www-data permission (for apache2 user)
RUN chown -R www-data:www-data /var/www/html/lumen/storage

# rust cargo setup
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
RUN echo 'source $HOME/.cargo/env' >> $HOME/.bashrc

# Set the environment variables for the current shell session
ENV PATH="/root/.cargo/bin:${PATH}"

# working directory
WORKDIR /var/www/html/

# copy cargo file into container
COPY compose/Cargo/. ./cargo

# run the docker ssh tunnel server
CMD service ssh start && apache2-foreground