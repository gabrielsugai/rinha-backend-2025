class CheckHealthWorker
  include Sidekiq::Worker
  sidekiq_options queue: :default, retry: false, backtrace: true

  def perform
    default_response = get_default_processor_health
    fallback_response = get_fallback_processor_health

    result = choose_processor(default_response, fallback_response)
    redis.set('payment_processor', result)
  end

  def get_default_processor_health
    url = "#{ENV['PAYMENT_PROCESSOR_DEFAULT_URL']}/payments/service-health"
    response = Faraday.get(url).body
    JSON.parse(response, symbolize_names: true)
  end

  def get_fallback_processor_health
    url = "#{ENV['PAYMENT_PROCESSOR_FALLBACK_URL']}/payments/service-health"
    response = Faraday.get(url).body
    JSON.parse(response, symbolize_names: true)
  end

  def choose_processor(default, fallback)
    return 'fallback' if default[:failing] && !fallback[:failing]
    return 'default' if fallback[:failing] && !default[:failing]

    if !default[:failing] && !fallback[:failing]
      return default[:minResponseTime] <= fallback[:minResponseTime] ? 'default' : 'fallback'
    end

    'default'
  end

  def redis
    @redis ||= Redis.new(url: ENV.fetch('REDIS_URL', 'localhost'))
  end
end
