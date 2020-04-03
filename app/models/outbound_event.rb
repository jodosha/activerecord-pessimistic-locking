# frozen_string_literal: true

class OutboundEvent < ApplicationRecord
  scope :unprocessed, -> { where(processed_at: nil) }
  # IMPORTANT: to preserve the order, the SQL order clause must consider `published_at` first, and then `key`
  scope :for_processing, -> { lock("FOR UPDATE SKIP LOCKED").unprocessed.order(:published_at, :key) }

  def self.mark_processed(outbound_event_ids)
    where(id: outbound_event_ids)
      .update_all(processed_at: Time.now.utc)
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
