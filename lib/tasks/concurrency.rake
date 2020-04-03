# frozen_string_literal: true

namespace :concurrency do
  task test: :environment do
    concurrency_level = ActiveRecord::Base.connection_pool.size

    loop do
      concurrency_level.times.map do
        Thread.new do
          OutboundEvent.transaction do
            events = OutboundEvent.for_processing
            events.each do |event|
              puts "[debug] processing #{event.id}"
              DeliveryBoy.produce!(event.payload.to_json, topic: event.name, partition_key: event.partition_key)
            end

            DeliveryBoy.deliver_messages
            OutboundEvent.mark_processed(events.ids)
          end
        end
      end

      sleep 1
    end
  end
end
