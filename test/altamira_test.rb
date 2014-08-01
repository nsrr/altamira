require 'test_helper'

class AltamiraTest < Minitest::Test

  def test_nsrr_application
    assert_kind_of Module, Altamira
  end

  def test_nsrr_version
    assert_kind_of String, Altamira::VERSION::STRING
  end

end
