# frozen_string_literal: true

require 'rubygems'
require 'edfize'

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'altamira'

config_reader = Altamira::Helpers::ConfigReader.new

app = proc do |env|
  begin
    req = Rack::Request.new(env)
    params = req.params

    slug = params['slug']
    path = params['path']

    @json_object = Altamira::Helpers::JsonRequest.get("#{config_reader.url}/datasets.json", req.cookies)

    @access_hash = Altamira::Helpers::JsonRequest.get("#{config_reader.url}/datasets/#{params['slug']}/access/#{params['path']}", req.cookies) || {}

    @page = (params['page'].to_i > 1 ? params['page'].to_i : 1 )
    # Default Window Size should equal 30 second increments, @window is in seconds
    @window = (params['window'].to_i.positive? && params['window'].to_i <= 60 ? params['window'].to_i : 30)
    @data_records_per_window = 1

    @epoch_number = @page
    @epoch_window = @window
    @edf_name = ''
    @edf = nil

    if @access_hash['result']
      @edf_name = File.join(Dir.pwd, "#{config_reader.location}/#{@access_hash['dataset_id']}/files/#{@access_hash['path']}")
      @edf = Edfize::Edf.new(@edf_name) rescue nil
    end

    @max_page = 1

    if @edf
      # 30 second per window / 1 second per sample = 30 samples per window
      @data_records_per_window = (@window.to_f / @edf.duration_of_a_data_record).ceil
      @max_page = [(@edf.number_of_data_records.to_f * @edf.duration_of_a_data_record / @window).ceil, 1].max
      @page = [@page, @max_page].min
      @edf.load_epoch(@page - 1, @window)
    end

    @samples_per_page = @data_records_per_window

    @signal_height = (params['signal'].to_i >= 1 ? params['signal'].to_i : 50)
    @signal_padding = 20

    @staging_file_xml = @edf_name.gsub(/\.edf$/i, '-profusion.xml').gsub(%r{/edfs/}, '/annotations-events-profusion/')
    @staging_file_csv = @edf_name.gsub(/\.edf$/i, '-staging.csv').gsub(%r{/edfs/}, '/annotations-staging/')

    @stages = []

    if File.exist?(@staging_file_xml)
      annotation = Altamira::Annotation.new(@staging_file_xml)
      @stages = annotation.sleep_stages
    elsif File.exist?(@staging_file_csv)
      begin
        File.open(@staging_file_csv, 'r') do |f|
          index = -1
          f.each_line do |line|
            index += 1
            next if index.zero?
            @stages << line.split(',')[1].to_i
          end
        end
      rescue
      end
    end

    Altamira.render_body(%w(body), binding)
  rescue => e
    Altamira.error_page(e)
  end
end

require 'sprockets'

map '/assets' do
  environment = Sprockets::Environment.new
  environment.append_path 'app/assets/javascripts'
  environment.append_path "#{Gem::Specification.find_by_name('turbolinks-source').lib_dirs_glob}/assets/javascripts"
  # environment.append_path 'app/assets/stylesheets'
  run environment
end

if ENV['PASSENGER_APP_ENV'] == 'development'
  debug = proc do |env|
    Altamira.render_page(%w(debug), env: env)
  end

  map '/debug' do
    run debug
  end
end

map '/' do
  run app
end
