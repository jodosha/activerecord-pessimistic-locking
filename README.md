# README

Reproduce ActiveRecord _pessimistic locking_ strategy in a multi-threaded environment.

## Requirements

  * Ruby / Bundler
  * Foreman
  * PostgreSQL
  * Kafka

## How to run the test

  1. Clone this repository
  1. Start PostgreSQL & Kafka
  1. Run `bin/setup`
  1. Run `foreman start`
  1. In another shell run `bundle exec rails dbconsole` and then `SELECT * FROM inbound_events ORDER BY id`. Verify that `id`, `offset`, and `counter` (from `payload`) are all progressive numbers. This is the proof that they were stored in the same order they were produced (according to `outbound_events.published_at`)
