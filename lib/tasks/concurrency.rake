# frozen_string_literal: true

namespace :concurrency do # rubocop:disable Metrics/BlockLength
  task test: :environment do
    concurrency_level = ActiveRecord::Base.connection_pool.size

    loop do
      concurrency_level.times.map do
        Thread.new do
          OutboundEvent.find_each_processable do |oe|
            oe.lock!
            oe.reload
            next if oe.processed?

            WaterDrop::SyncProducer.call(oe.payload.to_json,
                                         topic: oe.name,
                                         partition_key: oe.partition_key)

            oe.processed!
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
