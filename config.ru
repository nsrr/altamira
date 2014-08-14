require 'rubygems'
require 'edfize'
require 'erb'

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'altamira'

@edf_names = Dir.glob('tmp/*.edf').sort

app = proc do |env|
  begin
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
