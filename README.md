# README

Reproduce ActiveRecord _pessimistic locking_ strategy in a multi-threaded environment.

## Requirements

  * Ruby / Bundler
  * PostgreSQL

## How to run the test

  1. Clone this repository
  1. Run `bundle install`
  1. Run `bundle exec rake db:create db:migrate db:seed`
  1. Run `bundle exec rake concurrency:test`. This command runs an endless loop that periodically tries to fetch new events from the database.
  1. [Optional] While the `concurrency:test` task is done processing, but still running, you can run again `bundle exec rake db:seed` to simulate a new batch of events to process.

The `concurrency:test` command raises errors in the 10% of the cases to simulate Kafka errors. The process will automatically enqueue the failed event again.
