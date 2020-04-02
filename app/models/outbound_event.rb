# frozen_string_literal: true

class OutboundEvent < ApplicationRecord
  scope :unprocessed, -> { where(processed_at: nil) }
  scope :for_processing, -> { lock("FOR UPDATE SKIP LOCKED").unprocessed.order(:key, :published_at).first }
  scope :for_broken_processing, -> { lock.unprocessed.order(:key, :published_at).first }

  def processed?
    processed_at.present?
  end

  def processed!
    update!(processed_at: Time.now.utc)
  end
end
