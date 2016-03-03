# frozen_string_literal: true

require 'simplecov'

require 'minitest/autorun'
require 'minitest/reporters'
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

require File.expand_path('../../lib/altamira', __FILE__)
