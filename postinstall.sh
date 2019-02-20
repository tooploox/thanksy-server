#!/bin/sh

bundle exec rake db:migrate
./scripts/build_client.sh
