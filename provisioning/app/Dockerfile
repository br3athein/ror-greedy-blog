FROM ruby:3.1.2

RUN set -e \
    && apt update && apt install -y \
    gosu \
    sqlite3 \
    && gem install rails \
    && echo \
    && echo 'Done setting up.' \
    && ruby --version \
    && rails --version \
    && echo sqlite $(sqlite3 --version) \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir /app \
    && useradd -ms /bin/bash --no-user-group -u 4242 rails

COPY app /app
COPY provisioning/app/docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

WORKDIR /app
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["bash"]
