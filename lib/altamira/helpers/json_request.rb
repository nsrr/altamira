# frozen_string_literal: true

require 'openssl'
require 'net/http'
require 'json'

module Altamira
  module Helpers
    # Class to do a JSON request to the NSRR
    class JsonRequest
      class << self
        def get(*args)
          new(*args).get
        end
      end

      attr_reader :url

      def initialize(url, cookies = {})
        @url = URI.parse(url)
        @http = Net::HTTP.new(@url.host, @url.port)
        @cookies = cookies

        if @url.scheme == 'https'
          @http.use_ssl = true
          @http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        end
      rescue
        nil
      end

      def get
        req = Net::HTTP::Get.new(@url.path, 'Cookie' => @cookies.collect { |k, v| "#{k}=#{v};" }.join(' '))
        response = @http.start do |http|
          http.request(req)
        end
        JSON.parse(response.body)
      rescue
        nil
      end
    end
  end
end
