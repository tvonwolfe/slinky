FROM ruby:3.4.5

ADD . /slinky
WORKDIR /slinky

RUN apt-get update

RUN bundle config set --local without 'development test'
RUN bundle install

ENV RACK_ENV production

COPY ./bin/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

CMD ["bundle", "exec", "rackup", "-o", "0.0.0.0"]
