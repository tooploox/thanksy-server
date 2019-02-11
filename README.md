# Thanksy

[![CircleCI](https://circleci.com/gh/tooploox/thanksy-server/tree/master.svg?style=svg&circle-token=785972e2d5ae5f788b329e1fb5172cc2ee5a4a07)](https://circleci.com/gh/tooploox/thanksy-server/tree/master)

## Deployment

    heroku create
    git push heroku master
    heroku run rake db:migrate
    heroku open


Alternatively, you can deploy your own copy of the app using the web-based flow:

[![Deploy to Heroku](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

## Building slack app

1. Visit the [Slack API vebsite](https://api.slack.com/) and click the `Start Building` button.
Then you will see the following popup. Fill in the name of the application (We recommend name `Thanksy`) and select your workspace.

![Create a Slack App](./instruction/step1.png)

2. The next step is to configure two commands. Click `Features -> Slash Commands` and use the `Create New Command` option to create them.
Remember to enter the appropriate server address. Replace the `thanksy.server` placeholder with the address of the application you deployed in the previous step.

![Create New Command](./instruction/step2.png)

![Create New Command](./instruction/step3.png)

3. `Click Features -> Interactive Components` and turn them on.

![Interactive Components](./instruction/step4.png)

4. Fill in the `Request URL` used to send slack reactions. Replace the `thanksy.server` placeholder with the address of the application you deployed in the previous step.

![Interactive Components](./instruction/step5.png)

5. At this step, specify a scopes. Thanksy saves some data to minimize the number of requests to the `Slack API` . To fetch this data, we require the following permissions:

![Scopes](./instruction/step6.png)

6. If the scopes have been defined you can install you app.

![Installation](./instruction/step7.png)

## Development

### Prerequisites

    ruby 2.6.1

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

    rails s

### Run tests

    rspec
