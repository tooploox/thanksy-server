# Thanksy

[![CircleCI](https://circleci.com/gh/tooploox/thanksy-server/tree/master.svg?style=svg&circle-token=785972e2d5ae5f788b329e1fb5172cc2ee5a4a07)](https://circleci.com/gh/tooploox/thanksy-server/tree/master)

## Deployment

You can easily deploy our API application on heroku using the `Deploy to Heroku` button.

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

## Development

### Prerequisites

- ruby 2.6.1

### PostgreSQL

If you don't have `PostgreSQL` locally, you can start a `Docker` container with following command:

    ./scripts/run_postgres.sh

### Fill .env

    cp .env.example .env

Then fill missing options in the `.env` file.

### Install dependencies

    bundle install

### Setup db

    rake db:recreate
    rake db:migrate

### Run the server

    ./scripts/server.sh

### Run tests

    ./scripts/tests.sh
