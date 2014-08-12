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
run app
