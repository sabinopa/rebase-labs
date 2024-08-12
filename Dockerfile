FROM ruby:latest

WORKDIR /app

COPY backend/Gemfile backend/Gemfile.lock ./

RUN gem install bundler && bundle install

COPY . .

EXPOSE 3000

CMD ["ruby", "server.rb"]
