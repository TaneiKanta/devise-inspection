#!/bin/sh
RAILS_PORT=3000
if [ -n "$PORT" ]; then
    RAILS_PORT=$PORT
fi

rm -f tmp/pids/server.pid

if [ -z "$RAILS_ENV" ]; then
    exec "$@"
fi

if [ "$RAILS_ENV" = "production" ]; then
    RAILS_ENV=$RAILS_ENV bin/rails db:migrate
    RAILS_ENV=$RAILS_ENV bin/rails db:seed_fu
    RAILS_ENV=$RAILS_ENV bin/rails assets:precompile
    RAILS_ENV=$RAILS_ENV bin/rails s -p $RAILS_PORT -b 0.0.0.0
fi

if [ "$RAILS_ENV" = "staging" ]; then
    RAILS_ENV=$RAILS_ENV bin/rails s -p $RAILS_PORT -b 0.0.0.0
fi