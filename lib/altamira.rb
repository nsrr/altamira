# frozen_string_literal: true

require "altamira/helpers/all"
require "altamira/models/all"
require "altamira/version"
require "erb"

# Stub for Altamira functionality
module Altamira
  def self.render_body(binding)
    [
      200,
      { "Content-Type" => "text/html" },
      [ERB.new(File.read("views/body.html.erb")).result(binding)]
    ]
  rescue StandardError => e
    error_page(e)
  end

  def self.render_page(binding, env: {})
    [
      200,
      { "Content-Type" => "text/html" },
      [ERB.new(File.read("views/layout.html.erb")).result(binding)]
    ]
  rescue StandardError => e
    error_page(e)
  end

  def self.render_text
    [200, { "Content-Type" => "text/plain" }, ["Text"]]
  end

  def self.error_page(e)
    if ENV["PASSENGER_APP_ENV"] == "development"
      [400, { "Content-Type" => "text/plain" }, [e.backtrace_string]]
    else
      [400, { "Content-Type" => "text/plain" }, ["We're sorry, something went wrong."]]
    end
  end
end
