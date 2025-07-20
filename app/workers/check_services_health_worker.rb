require 'net/http'

class CheckServicesHealthWorker
  include Sidekiq::Worker
  sidekiq_options queue: :health_check, retry: false, backtrace: true

  def perform
    url = "#{ENV['PAYMENT_PROCESSOR_DEFAULT_URL']}/payments/service-health"
    12.times do |i|
      puts "Checking services health..."
      response = Faraday.get(url)
      puts response.body
      sleep(5)
    end
  end
end
