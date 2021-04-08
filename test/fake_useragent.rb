# frozen_string_literal: true

# $LOAD_PATH << File.dirname(__FILE__)
require 'test/unit'
require '../user_agent/base'
require '../user_agent/error'

class TestSuite < Test::Unit::TestCase
  include Test::Unit::Assertions
  def test_platform
    50.times do
      assert_include(generate_user_agent(os: 'linux'), 'Linux', 'Linux not in `ua`, where os: `linux`')
      assert_include(generate_user_agent(os: 'win'), 'Windows', 'Windows not in `ua`, where os: `win`')
      assert_include(generate_user_agent(os: 'mac'), 'Mac', 'Mac not in `ua`, where os: `mac`')
    end
  end

  def test_invalid_platform
    assert_raises(InvalidOption, generate_user_agent(os: 11))
  end
end
