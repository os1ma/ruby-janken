FROM ruby:3.0.0-slim-buster

RUN apt update \
  && apt-get install -y \
    build-essential \
    libpq-dev \
    git
