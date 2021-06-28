module Sms
  class Client
    attr_reader :client, :from, :to, :message

    def initialize(to:, message:)
      @client = ::SMS_CLIENT
      @from = "+#{Rails.application.secrets.twilio_number}"
      @to = "+#{to}"
      @message = message
    end

    def perform
      return unless from.present? && client.present?

      client.messages.create(from: from, to: to, body: message)
    end
  end
end
