FROM ruby:latest

WORKDIR /app

COPY backend/Gemfile backend/Gemfile.lock ./
RUN gem install bundler && bundle install

COPY backend/ /app/backend/

COPY frontend/Gemfile frontend/Gemfile.lock ./
RUN gem install bundler && bundle install

COPY frontend/ /app/frontend/

EXPOSE 3000 2000
