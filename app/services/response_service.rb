# frozen_string_literal: true

class ResponseService
  FACEBOOK_URI = 'https://takehome.io/facebook'
  INSTAGRAM_URI = 'https://takehome.io/instagram'
  TWITTER_URI = 'https://takehome.io/twitter'

    def initialize
      @web_data = Hash.new
      @output = Hash.new
    end


    def call
      collect_web_responses
      format_web_responses
    end

    private

    def collect_web_responses
      self.class.constants.each do |uri|
        web_response = Net::HTTP.get(URI.parse(self.class.const_get(uri)))
        @web_data[uri] = web_response
      end
    end

    def format_web_responses
      @web_data.each do |uri, value|
        endpoint = uri.to_s.split('_')[0].downcase

        begin
          case endpoint
          when 'facebook'
            @output[endpoint.to_sym] = JSON.parse(value).pluck('status')
          when 'instagram'
            @output[endpoint.to_sym] = JSON.parse(value).pluck('photo')
          when 'twitter'
            @output[endpoint.to_sym] = JSON.parse(value).pluck('tweet')
          end
        rescue JSON::ParserError => e
          @output[endpoint.to_sym] = e.message.split("at ")[1].delete("'").strip
        end
      end

      @output
    end
end