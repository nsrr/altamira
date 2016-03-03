# frozen_string_literal: true

require 'yaml'

module Altamira
  module Helpers
    # Helper to quickly read and parse `.sleepdata.yml`
    class ConfigReader
      attr_reader :url, :location, :asset_path

      def initialize
        @url = ''
        @location = ''
        parse_yaml_file
      end

      def parse_yaml_file
        sleepdata_config = YAML.load_file('.sleepdata.yml')

        if sleepdata_config.is_a? Hash
          @url = sleepdata_config['url'].to_s.strip
          @location = sleepdata_config['location'].to_s.strip
          @asset_path = sleepdata_config['asset_path'].to_s.strip
        end
      rescue
        nil
      end
    end
  end
end
