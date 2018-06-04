FROM ruby
WORKDIR /usr/local/app
ADD Gemfile .
RUN bundle install
