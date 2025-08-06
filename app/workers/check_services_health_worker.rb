class CheckServicesHealthWorker
  include Sidekiq::Worker
  sidekiq_options queue: :health_check, retry: false, backtrace: true

  def perform
    [0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55].each do |i|
      CheckHealthWorker.perform_in(i.seconds)
    end
  end
end
