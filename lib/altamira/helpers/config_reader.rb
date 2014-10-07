require 'yaml'

module Altamira
  module Helpers
    class ConfigReader

      attr_reader :url, :location


      def initialize
        @url = ""
        @location = ""
        parse_yaml_file
      end

      def parse_yaml_file
        begin
          sleepdata_config = YAML.load_file('.sleepdata.yml')

          if sleepdata_config.kind_of?(Hash)
            @url = sleepdata_config['url'].to_s.strip
            @location = sleepdata_config['location'].to_s.strip
          end
        rescue => e
        end
      end

    end
  end
end
