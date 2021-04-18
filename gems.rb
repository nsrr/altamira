# frozen_string_literal: true

# rubocop:disable Layout/ExtraSpacing
source "https://rubygems.org"

gem "edfize",            "~> 0.6.0"
gem "rack",              "~> 2.0.1"
gem "rake",              "~> 12.0.0"
gem "xml-simple",        "~> 1.1.8"
gem "rexml",             "~> 3.2.5"

gem "coffee-script"
gem "sprockets",         "~> 3.7.0"
gem "turbolinks-source", "~> 5.0.0"

# Testing
group :test do
  gem "minitest"
  gem "simplecov",       "~> 0.16.1", require: false
end
# rubocop:enable Layout/ExtraSpacing
