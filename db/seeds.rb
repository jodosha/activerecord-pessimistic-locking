# frozen_string_literal: true

require "securerandom"

100.times do |i|
  OutboundEvent.create!(
    key: "gid://company-#{::Kernel.rand(10).to_i}",
    name: "test",
    payload: { counter: i },
    published_at: Time.now.utc
  )
end
