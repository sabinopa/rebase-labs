FROM ruby:3.1

WORKDIR /app

RUN apt-get update -y && apt-get install -y chromium-driver

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .

EXPOSE 3000


