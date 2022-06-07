FROM ruby:3.0.0

RUN set -e \
    && mkdir -p /app \
    && apt update && apt install -y \
    sqlite3 \
    && gem install rails \
    && echo \
    && echo 'Done setting up.' \
    && ruby --version \
    && rails --version \
    && echo sqlite $(sqlite3 --version) \
    && apt clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY app /app
WORKDIR /app
RUN bundle install

CMD ["bin/rails", "server"]
