# frozen_string_literal: true

# rubocop:disable Layout/ExtraSpacing
source "https://rubygems.org"

gem "edfize",            "~> 0.6.0"
gem "rack",              "~> 2.2.3"
gem "rake",              "~> 13.0.3"
gem "xml-simple",        "~> 1.1.8"
gem "rexml",             "~> 3.2.5"

gem "coffee-script"
gem "sprockets",         "~> 4.0.2"
gem "turbolinks-source", "~> 5.2.0"

# Testing
group :test do
  gem "minitest"
  gem "simplecov",       "~> 0.21.2", require: false
end
# rubocop:enable Layout/ExtraSpacing
