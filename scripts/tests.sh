#!/usr/bin/env bash

RACK_ENV=test rake db:recreate
RACK_ENV=test rake db:migrate
bundle exec rspec
