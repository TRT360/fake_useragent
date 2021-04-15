# frozen_string_literal: true

require 'test/unit'
require './lib/fake_useragent'
require './lib/fake_useragent/error'

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
    assert_raise(InvalidOption) { generate_user_agent(os: 11) }
    assert_raise(InvalidOption) { generate_user_agent(os: 'minecraft') }
    assert_raise(InvalidOption) { generate_user_agent(os: 'Putin, Sabaton, win') }
  end

  def test_navigator
    50.times do
      assert_include(generate_user_agent(navigator: 'firefox'), 'Firefox', 'Firefox not in `ua`, where navigator: `firefox`')
      assert_include(generate_user_agent(navigator: 'chrome'), 'Chrome', 'Chrome not in `ua`, where navigator: `chrome`')
      # not passing
      agent = generate_user_agent(navigator: 'ie')
      assert((agent.include? 'MSIE') || (agent.include? 'rv:11'))
    end
  end

  def test_invalid_navigator
    assert_raise(InvalidOption) { generate_user_agent(navigator: 'win') }
    assert_raise(InvalidOption) { generate_user_agent(navigator: 'linux, mac') }
  end

  def test_invalid_navigator_array
    50.times do
      assert_nothing_raised do
        generate_user_agent(navigator: %w[firefox])
        generate_user_agent(navigator: %w[firefox chrome])
        generate_user_agent(navigator: %w[firefox chrome ie])
      end
    end
  end

  def test_platform_array
    50.times do
      assert_nothing_raised do
        generate_user_agent(os: %w[win linux mac])
        generate_user_agent(os: %w[mac])
        generate_user_agent(os: %w[win linux])
        generate_user_agent(os: %w[linux])
        generate_user_agent(os: %w[win])
      end
    end
  end

  def test_platform_navigator
    50.times do
      agent = generate_user_agent(os: 'win', navigator: 'firefox')
      assert((agent.include? 'Firefox') && (agent.include? 'Windows'))
      agent = generate_user_agent(os: 'win', navigator: 'chrome')
      assert((agent.include? 'Chrome') && (agent.include? 'Windows'))
      agent = generate_user_agent(os: 'win', navigator: 'ie')
      assert((agent.include? 'MSIE') || (agent.include? 'rv:11'))
    end
  end

  def test_platform_linux
    50.times do
      assert(generate_user_agent(os: 'linux').start_with?('Mozilla/5.0 (X11;'))
    end
  end

  def test_mac_chrome
    50.times do
      agent = generate_user_agent(os: 'mac', navigator: 'chrome')
      assert(!agent.match(/OS X \d+_\d+_\d+/).to_a.empty?)
    end
  end

  def test_impossible_combination
    50.times do
      assert_raise(InvalidOption) { generate_user_agent(os: 'linux', navigator: 'ie') }
      assert_raise(InvalidOption) { generate_user_agent(os: 'mac', navigator: 'ie') }
    end
  end

  def test_generate_navigator_js
    50.times do
      navigator = generate_navigator_js
      assert navigator.keys == %w[appCodeName appName appVersion platform userAgent oscpu product productSub vendor vendorSub buildID]
      assert navigator['appCodeName'] == 'Mozilla'
      assert ['Netscape', 'Microsoft Internet Explorer'].include? navigator['appName']
    end
  end

  def test_data_integrity
    50.times do
      navigator = generate_navigator
      navigator.each_value do |value|
        assert(value.nil? || (value.instance_of? String))
      end
    end
  end

  def test_feature_platform
    50.times do
      nav = generate_navigator(os: 'win')
      assert nav['platform'].include? 'Win'
      nav = generate_navigator(os: 'linux')
      assert nav['platform'].include? 'Linux'
      nav = generate_navigator(os: 'mac')
      assert nav['platform'].include? 'MacIntel'
    end
  end

  def test_feature_os_cpu
    10.times do
      nav = generate_navigator(os: 'win')
      assert nav['os_cpu'].include? 'Windows NT'
      nav = generate_navigator(os: 'linux')
      assert nav['os_cpu'].include? 'Linux'
      nav = generate_navigator(os: 'mac')
      assert nav['os_cpu'].include? 'Mac OS'
    end
  end

  def test_chrome_app_version
    50.times do
      nav = generate_navigator_js(navigator: 'chrome')
      assert(("Mozilla/#{nav['appVersion']}") == nav['userAgent'])
    end
  end

  def test_feature_product
    50.times do
      assert generate_navigator_js(navigator: 'chrome')['product'] == 'Gecko'
    end
  end

  def test_feature_vendor
    50.times do
      assert generate_navigator_js(navigator: 'chrome')['vendor'] == 'Google Inc.'
      assert generate_navigator_js(navigator: 'firefox')['vendor'] == ''
      assert generate_navigator_js(navigator: 'ie')['vendor'] == ''
    end
  end

  def test_feature_vendor_sub
    50.times do
      assert generate_navigator_js(navigator: 'chrome')['vendorSub'] == ''
    end
  end

  def test_build_id_no_firefox
    50.times do
      nav = generate_navigator(navigator: 'chrome')
      assert nav['build_id'] == ''
      nav = generate_navigator(navigator: 'ie')
      assert nav['build_id'] == ''
    end
  end

  def test_build_id_firefox
    original_ff_version = FIREFOX_VERSION.clone
    FIREFOX_VERSION.replace [
      ['49.0', Time.new(2016, 9, 20)],
      ['50.0', Time.new(2016, 11, 15)]
    ].freeze
    begin
      50.times do
        nav = generate_navigator(navigator: 'firefox')
        assert nav['build_id'].length == 14
        if nav['user_agent'].include? '50.0'
          assert nav['build_id'].start_with? '20161115'
        else
          time_ = Time.at(nav['build_id'].to_i)
          assert Time.new(2016, 9, 20, 0) <= time_
        end
      end
    ensure
      FIREFOX_VERSION.replace original_ff_version
    end
  end

  def test_android_firefox
    50.times do
      nav = generate_navigator_js(os: 'android', navigator: 'firefox')
      assert nav['platform'].include? 'armv'
      assert nav['oscpu'].include? 'Linux armv'
      assert nav['appVersion'].include? 'Android'
      assert nav['userAgent'].split('(')[1].split(')')[0].include? 'Android'
    end
  end

  def test_device_type
    50.times do
      agent = generate_user_agent(device_type: 'smartphone')
      assert agent.include? 'Android'
      assert (agent.include? 'Firefox') || (agent.include? 'Chrome')
    end
  end

  def test_invalid_device_type
    50.times do
      assert_raise(InvalidOption) { generate_user_agent(device_type: 'computer') }
    end
  end

  def invalid_device_type_with_os
    50.times do
      assert_raise(InvalidOption) { generate_user_agent(os: 'win', device_type: 'smartphone') }
    end
  end

  def invalid_dev_type_with_nav
    50.times do
      assert_raise(InvalidOption) { generate_user_agent(device_type: 'smartphone', navigator: 'ie') }
    end
  end

  def default_device_without_os
    50.times do
      assert_not_include(generate_user_agent, 'Android')
      # if os is default then device_type is 'desktop'
    end
  end

  def all_device_types
    50.times do
      generate_user_agent(device_type: 'all')
      generate_user_agent(device_type: 'all', navigator: 'ie')
    end
  end

  def dev_type_smartphone_chrome
    50.times do
      assert_include(generate_user_agent(device_type: 'smartphone', navigator: 'chrome'), 'Mobile')
      assert_include(generate_user_agent(device_type: 'tablet', navigator: 'chrome'), 'Mobile')
    end
  end
end
