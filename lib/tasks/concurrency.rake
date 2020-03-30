# frozen_string_literal: true

namespace :concurrency do
  task test: :environment do
    concurrency_level = ActiveRecord::Base.connection_pool.size

    loop do
      concurrency_level.times.map do
        Thread.new do
          OutboundEvent.transaction do
            event = OutboundEvent.for_processing

            if event.is_a?(OutboundEvent)
              puts "[debug] processing #{event.id}"
              sleep 0.5

              if Kernel.rand(100) < 10
                puts "[debug] error on event #{event.id}"
                raise ActiveRecord::Rollback, "Kafka error"
              end

              event.processed!
            end
          end
        end
      end

      sleep 1
    end
  end
end
