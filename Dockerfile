FROM ruby:3.2.0-preview3-slim
WORKDIR /usr/local/app
ADD Gemfile .
RUN bundle install
