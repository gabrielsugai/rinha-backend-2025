class Api::PaymentsController < ApplicationController

  def sumary
  end

  def create
  end

  private

  def params_adapter
    {
      correlation_id: params[:correlationId],
      amount: params[:amount],
      requested_at: Time.zone.now
    }
  end

  def payment_processor
    redis.get('payment_processor') || 'default'
  end

  def default_processor
    url = "#{ENV['PAYMENT_PROCESSOR_DEFAULT_URL']}/payments"
    response = Faraday.post(url)
  end

  def fallback_processor
    url = "#{ENV['PAYMENT_PROCESSOR_FALLBACK_URL']}/payments"
    response = Faraday.post(url)
  end
end
