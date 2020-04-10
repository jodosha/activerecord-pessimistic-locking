# frozen_string_literal: true

require "zlib"

class OutboundEvent < ApplicationRecord
  scope :unprocessed, -> { where(processed_at: nil) }
  scope :for_processing, -> { unprocessed.order(:published_at, :key) }

  def self.find_each_processable
    with_advisory_lock do
      for_processing.find_each do |outbound_event|
        yield outbound_event
      end
    end
  end

  def self.with_advisory_lock
    return unless acquire_avisory_lock

    begin
      yield
    ensure
      release_advisory_lock
    end
  end

  def self.acquire_avisory_lock
    connection.select_value("select pg_try_advisory_lock(#{advisory_lock_key});")
  end

  def self.release_advisory_lock
    connection.execute("select pg_advisory_unlock(#{advisory_lock_key});")
  end

  def self.advisory_lock_key
    x = Zlib.crc32(table_name)
    x = (x << 1) while x.bit_length < 32
    x
  end

  def processed?
    processed_at.present?
  end

  def processed!
    update!(processed_at: Time.now.utc)
  end

  def partition_key
    key.scan(/[[:digit:]]/).first
  end
end
