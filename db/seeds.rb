# frozen_string_literal: true

require "securerandom"

100.times do
  OutboundEvent.create!(
    key: SecureRandom.uuid,
    name: "test",
    payload: {},
    published_at: Time.now.utc
  )
end
