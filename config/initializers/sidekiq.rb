redis_domain = ENV['SETLISTRRAILS_REDIS_1_PORT_6379_TCP_ADDR']  
redis_port   = ENV['SETLISTRRAILS_REDIS_1_PORT_6379_TCP_PORT']

if redis_domain && redis_port  
  redis_url = "redis://#{redis_domain}:#{redis_port}"

  Sidekiq.configure_server do |config|
    config.redis = {
      url: redis_url
    }
  end

  Sidekiq.configure_client do |config|
    config.redis = {
      url: redis_url
    }
  end
end  