FROM ruby:3.0.0

RUN set -e \
    && mkdir -p /app \
    && apt-get update && apt-get install -y \
    sqlite3 \
    && gem install rails \
    && echo \
    && echo 'Done setting up.' \
    && ruby --version \
    && rails --version \
    && echo sqlite $(sqlite3 --version) \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY app /app
WORKDIR /app
RUN bundle install

CMD ["bin/rails", "server", "--binding", "0.0.0.0", "--port", "3000"]

EXPOSE 3000
