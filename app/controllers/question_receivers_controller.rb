class QuestionReceiversController < ::ApplicationController
  skip_forgery_protection
  skip_after_action :verify_authorized

  def index
    from = parsed_params.fetch(:from)&.first
    body = parsed_params.fetch(:body)&.first

    if from.present? && body.present?
      # PARSED THE INITIAL SMS BODY
      summary = service.perform

      if summary.blank?
        render json: { errors: ::I18n.t('sms.summary.blank') }, status: :unprocessable_entity
      end

      # SEND ANOTHER SMS HERE
      sms_client.perform
    end

    if from.nil?
      render json: { errors: ::I18n.t('sms.from.blank') }, status: :unprocessable_entity
    end

    if body.nil?
      render json: { errors: ::I18n.t('sms.body.blank') }, status: :unprocessable_entity
    end

    render json: { summary: summary }, status: :ok
  end

  private

  def sms_client
    @_sms_client ||= ::Sms::Client.new(
      to: from,
      message: summary,
    )
  end

  def service
    @_service ||= ::Sms::ReceiverService.new(params: parsed_params)
  end

  def request_body
    @_request_body ||= request.body.read
  end

  def parsed_params
    @parsed_params ||= CGI.parse(request_body).deep_transform_keys! do |key|
      key.underscore.to_sym
    end
  end
end
