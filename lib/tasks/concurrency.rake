# frozen_string_literal: true

namespace :concurrency do
  task test: :environment do
    concurrency_level = ActiveRecord::Base.connection_pool.size

    loop do
      concurrency_level.times.map do
        Thread.new do
          OutboundEvent.find_each_processable do |outbound_event|
            puts "[debug] processing #{outbound_event.id}"
            WaterDrop::SyncProducer.call(outbound_event.payload.to_json,
                                         topic: outbound_event.name,
                                         partition_key: outbound_event.partition_key)

            outbound_event.processed!
          end
        end
      end

      sleep 1
    end
  end

  task data: :environment do
    sleep_time = (1..10).to_a

    loop do
      puts "New data #{Time.now.utc}"
      Rake::Task["db:seed"].invoke
      sleep sleep_time.sample
    end
  end
end
