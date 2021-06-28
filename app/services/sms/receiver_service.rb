require 'uri'
require 'net/http'

# Receive the SMS from a person
module Sms
  class ReceiverService
    attr_reader :params, :message

    def initialize(params:)
      @params = params
      @message = params.fetch(:body, nil).fetch(0, nil)
    end

    # Twilio Returns A String Io
    # Check If Phone Number Matches My Phone Number Before Sending Message Through To Twilio
    # Receive Data In And Parse The Data Looking For The Message Content
    def perform
      raise StandardError, 'Message is empty' if message.blank?
      # Message comes in

      # Get The Message From The SMS
      encoded_message = URI.encode(message)
      base_url = "https://html.duckduckgo.com/html/?q=#{encoded_message}"
      response = RestClient.get(base_url)
      content = response.body

      doc = Nokogiri::HTML(content)
      anchors = doc.search('a')

      # Find a random response that has an href
      anchor = anchors[2]
      # Add the use of try here or safe operation
      value = anchor.attributes['href'].value

      anchor ||= unless value.present?
        anchors.sample
      end

      # Query duckduckgo and get the first article response
      url = anchor.attribute('href').value

      # Summarize that article
      summarized_content = ::ArticleSummizer.new(url: url).perform
      summarized_content_length = summarized_content.length

      # if summarized_content_length >= 1_600
      #   raise StandardError, 'Content length is greater than 10,000'
      # end

      # This will not work with huge summaries
      if summarized_content_length >= 1_600
        summarized_content.slice(0, 1_1599)
      else
        summarized_content
      end
    end
  end
end
