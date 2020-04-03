# README

Reproduce ActiveRecord _pessimistic locking_ strategy in a multi-threaded environment.

## Requirements

  * Ruby / Bundler
  * PostgreSQL
  * Kafka

## How to run the test

  1. Clone this repository
  1. Start PostgreSQL & Kafka
  1. Run `bundle install`
  1. Run `bundle exec rake db:create db:migrate`
  1. In a first shell run `bundle exec rake concurrency:test`. This command runs an endless loop that periodically tries to fetch new outbound events from the database and send atomically to Kafka.
  1. In a second shell run `bundle exec karafka server`. This will read events from Kafka and write them as inbound events.
  1. In a third shell run `bundle exec rake db:seed` to simulate a new batch of outbound events to process.
  1. In a fourth shell run `bundle exec rails dbconsole` and then `SELECT * FROM inbound_events ORDER BY id`. Verify that `id`, `offset`, and `counter` (from `payload`) are all progressive numbers. This is the proof that they were stored in the same order they were produced (according to `outbound_events.published_at`)
