FROM ruby:2.5.0

RUN mkdir /app
WORKDIR /app
COPY . /app

RUN gem install bundler && bundle install

EXPOSE 4567

CMD rackup --host 0.0.0.0 --port 4567