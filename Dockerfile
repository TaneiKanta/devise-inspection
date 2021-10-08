FROM ruby:3.0.1

RUN wget --quiet -O - /tmp/pubkey.gpg https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo 'deb http://dl.yarnpkg.com/debian/ stable main' > /etc/apt/sources.list.d/yarn.list

RUN apt-get update && apt-get install -y \
                    mariadb-client \
                    default-libmysqlclient-dev \
                    nodejs \
                    imagemagick \
                    yarn \
                    tzdata \
                    vim

RUN yarn add jquery

RUN mkdir /devise-inspection

WORKDIR /devise-inspection

ADD Gemfile /devise-inspection

ADD Gemfile.lock /devise-inspection

ADD . /devise-inspection

RUN CFLAGS="-Wno-cast-function-type" \
    BUNDLE_FORCE_RUBY_PLATFORM=1 \
    bundle install

RUN yarn install --check-files
RUN bundle exec rails webpacker:compile

COPY start.sh /usr/bin/
RUN chmod +x /usr/bin/start.sh
ENTRYPOINT ["start.sh"]
EXPOSE 3000

CMD ["bin/start"]
