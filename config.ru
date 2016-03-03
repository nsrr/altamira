# frozen_string_literal: true

require 'rubygems'
require 'edfize'
require 'erb'

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'altamira'
require 'altamira/helpers/json_request'
require 'altamira/helpers/config_reader'

config_reader = Altamira::Helpers::ConfigReader.new

app = proc do |env|
  begin
    req = Rack::Request.new(env)
    params = req.params

    slug = params['slug']
    path = params['path']

    json_object = Altamira::Helpers::JsonRequest.get("#{config_reader.url}/datasets.json", req.cookies)

    access_hash = Altamira::Helpers::JsonRequest.get("#{config_reader.url}/datasets/#{params['slug']}/access/#{params['path']}", req.cookies) || {}

    @page = (params["page"].to_i > 1 ? params["page"].to_i : 1 )
    # Default Window Size should equal 30 second increments
    @window = (params["window"].to_i > 0 && params["window"].to_i <= 60 ? params["window"].to_i : 30) # @window is in seconds
    @data_records_per_window = 1

    @epoch_number = @page
    @epoch_window = @window
    @edf_name = ""
    @edf = nil

    if access_hash['result']
      @edf_name = File.join(Dir.pwd, "#{config_reader.location}/#{access_hash['dataset_id']}/files/#{access_hash['path']}")
      @edf = Edfize::Edf.new(@edf_name) rescue nil
    end

    @max_page = 1

    if @edf
      @data_records_per_window = (@window.to_f / @edf.duration_of_a_data_record).ceil # 30 second per window / 1 second per sample = 30 samples per window
      @max_page = [(@edf.number_of_data_records.to_f * @edf.duration_of_a_data_record / @window).ceil, 1].max
      @page = [@page, @max_page].min
      @edf.load_epoch(@page-1,@window)
    end

    @samples_per_page = @data_records_per_window

    @signal_height = (params['signal'].to_i >= 1 ? params['signal'].to_i : 50)
    @signal_padding = 20

    [200,
      { "Content-Type" => "text/html" },
      [ERB.new(File.read("views/body.html.erb")).result(binding)]
    ]
  rescue => e
    if env["PASSENGER_APP_ENV"] == 'development'
      [400, { 'Content-Type' => 'text/plain' }, [ e.backtrace_string ] ]
    else
      [400, { 'Content-Type' => 'text/plain' }, [ "We're sorry, something went wrong." ] ]
    end
  end
end

require 'sprockets'

map '/assets' do
  environment = Sprockets::Environment.new
  environment.append_path 'app/assets/javascripts'
  environment.append_path "#{Gem::Specification.find_by_name('turbolinks').lib_dirs_glob}/assets/javascripts"
  # environment.append_path 'app/assets/stylesheets'
  run environment
end

map '/' do
  run app
end
