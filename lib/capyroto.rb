require "capyroto/version"
require "sidekiq"
require "sidekiq/api"

module Capyroto

  class Monitor

    config_redis = { url: ENV["REDISTOGO_URL"] ,  namespace: 'mailcannon' }

    sidekiq_concurrency = ENV['SIDEKIQ_CONCURRENCY'] || 5

    Sidekiq.configure_server do |config|
      config.redis = config_redis

    end

    Sidekiq.configure_client do |config|
      config.redis = config_redis
    end

    def count_nurturing
      ids = Set.new
      queue = Sidekiq::Queue.new(ENV['QUEUE_NAME'])
      puts queue.count
      queue.each do |job|
        ids << job["args"][0]
      end
    end

  end

end
