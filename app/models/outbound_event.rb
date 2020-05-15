# frozen_string_literal: true

require "zlib"

class OutboundEvent < ApplicationRecord
  scope :unprocessed, -> { where(processed_at: nil) }
  scope :for_processing, -> { unprocessed.order(:published_at, :key) }

  def self.find_each_processable
    for_processing.find_each do |outbound_event|
      transaction do
        yield outbound_event
      end
    end
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
