require 'rubygems'
require 'edfize'
require 'erb'

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'altamira'

edf_names = Dir.glob('tmp/*.edf')
@edf = Edfize::Edf.new(edf_names.first) if edf_names.size > 0
@edf.load_signals if @edf

app = proc do |env|
  [200,
    { "Content-Type" => "text/html" },
    [ERB.new(File.read("views/body.html.erb")).result(binding)]
  ]
end
run app
