# frozen_string_literal: true

class InboundEventConsumer < ApplicationConsumer
  def consume
    params_batch.each do |params|
      InboundEvent.create!(name: params["topic"], payload: params["payload"].merge("offset" => params["offset"]))
    end
  end
end
