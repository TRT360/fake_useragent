# frozen_string_literal: true

require "minitest/autorun"
require "./lib/fake_useragent"
require "./lib/fake_useragent/core"
require "./lib/fake_useragent/error"

class TestSuite < Minitest::Test
  def test_platform
    50.times do
      assert_includes(generate_user_agent(os: "linux"), "Linux", "Linux not in `ua`, where os: `linux`")
      assert_includes(generate_user_agent(os: "win"), "Windows", "Windows not in `ua`, where os: `win`")
      assert_includes(generate_user_agent(os: "mac"), "Mac", "Mac not in `ua`, where os: `mac`")
    end
  end

  def test_invalid_platform
    assert_raises(InvalidOption) { generate_user_agent(os: 11) }
    assert_raises(InvalidOption) { generate_user_agent(os: "minecraft") }
    assert_raises(InvalidOption) { generate_user_agent(os: "Putin, Sabaton, win") }
  end

  def test_navigator
    50.times do
      assert_includes(generate_user_agent(navigator: "firefox"), "Firefox",
                      "Firefox not in `ua`, where navigator: `firefox`")
      assert_includes(generate_user_agent(navigator: "chrome"), "Chrome",
                      "Chrome not in `ua`, where navigator: `chrome`")
    end
  end

  def test_invalid_navigator
    assert_raises(InvalidOption) { generate_user_agent(navigator: "win") }
    assert_raises(InvalidOption) { generate_user_agent(navigator: "linux, mac") }
  end

  def test_invalid_navigator_array
    50.times do
      generate_user_agent(navigator: %w[firefox])
      generate_user_agent(navigator: %w[firefox chrome])
    end
  end

  def test_platform_array
    50.times do
      generate_user_agent(os: %w[win linux mac])
      generate_user_agent(os: %w[mac])
      generate_user_agent(os: %w[win linux])
      generate_user_agent(os: %w[linux])
      generate_user_agent(os: %w[win])
    end
  end

  def test_platform_navigator
    50.times do
      agent = generate_user_agent(os: "win", navigator: "firefox")
      assert((agent.include? "Firefox") && (agent.include? "Windows"))
      agent = generate_user_agent(os: "win", navigator: "chrome")
      assert((agent.include? "Chrome") && (agent.include? "Windows"))
    end
  end

  def test_platform_linux
    50.times do
      assert(generate_user_agent(os: "linux").start_with?("Mozilla/5.0 (X11;"))
    end
  end

  def test_mac_chrome
    50.times do
      agent = generate_user_agent(os: "mac", navigator: "chrome")
      assert(!agent.match(/OS X \d+_\d+(?:_\d+)?/).to_a.empty?)
    end
  end

  def test_generate_navigator_js
    50.times do
      navigator = generate_navigator_js
      assert navigator.keys == %w[appCodeName appName appVersion platform userAgent oscpu product productSub vendor
                                  vendorSub buildID]
      assert navigator["appCodeName"] == "Mozilla"
      assert ["Netscape", "Microsoft Internet Explorer"].include? navigator["appName"]
    end
  end

  def test_data_integrity
    50.times do
      navigator = Core.generate_navigator
      navigator.each_value do |value|
        assert(value.nil? || (value.instance_of? String))
      end
    end
  end

  def test_feature_platform
    50.times do
      nav = Core.generate_navigator(os: "win")
      assert nav["platform"].include? "Win"
      nav = Core.generate_navigator(os: "linux")
      assert nav["platform"].include? "Linux"
      nav = Core.generate_navigator(os: "mac")
      assert nav["platform"].include? "MacIntel"
    end
  end

  def test_feature_os_cpu
    10.times do
      nav = Core.generate_navigator(os: "win")
      assert nav["os_cpu"].include? "Windows NT"
      nav = Core.generate_navigator(os: "linux")
      assert nav["os_cpu"].include? "Linux"
      nav = Core.generate_navigator(os: "mac")
      assert nav["os_cpu"].include? "Mac OS"
    end
  end

  def test_chrome_app_version
    50.times do
      nav = generate_navigator_js(navigator: "chrome")
      assert("Mozilla/#{nav["appVersion"]}" == nav["userAgent"])
    end
  end

  def test_feature_product
    50.times do
      assert generate_navigator_js(navigator: "chrome")["product"] == "Gecko"
    end
  end

  def test_feature_vendor
    50.times do
      assert generate_navigator_js(navigator: "chrome")["vendor"] == "Google Inc."
      assert generate_navigator_js(navigator: "firefox")["vendor"] == ""
    end
  end

  def test_feature_vendor_sub
    50.times do
      assert generate_navigator_js(navigator: "chrome")["vendorSub"] == ""
    end
  end

  def test_build_id_no_firefox
    50.times do
      nav = Core.generate_navigator(navigator: "chrome")
      assert nav["build_id"] == ""
    end
  end

  def test_build_id_firefox
    original_ff_version = Core::FIREFOX_VERSION.clone
    Core::FIREFOX_VERSION.replace [
      ["49.0", Time.new(2016, 9, 20)],
      ["50.0", Time.new(2016, 11, 15)],
    ].freeze
    begin
      50.times do
        nav = Core.generate_navigator(navigator: "firefox")
        assert nav["build_id"].length == 14
        if nav["user_agent"].include? "50.0"
          assert nav["build_id"].start_with? "20161115"
        else
          time_ = Time.at(nav["build_id"].to_i)
          assert Time.new(2016, 9, 20, 0) <= time_
        end
      end
    ensure
      Core::FIREFOX_VERSION.replace original_ff_version
    end
  end

  def test_android_firefox
    50.times do
      nav = generate_navigator_js(os: "android", navigator: "firefox")
      assert nav["platform"].include? "arm"
      assert nav["oscpu"].include? "Linux arm"
      assert nav["appVersion"].include? "Android"
      assert nav["userAgent"].split("(")[1].split(")")[0].include? "Android"
    end
  end

  def test_device_type
    50.times do
      agent = generate_user_agent(device_type: "smartphone")
      assert agent.include? "Android"
      assert (agent.include? "Firefox") || (agent.include? "Chrome")
    end
  end

  def test_invalid_device_type
    50.times do
      assert_raises(InvalidOption) { generate_user_agent(device_type: "computer") }
    end
  end

  def test_invalid_device_type_with_os
    50.times do
      assert_raises(InvalidOption) { generate_user_agent(os: "win", device_type: "smartphone") }
    end
  end

  def test_default_device_without_os
    50.times do
      assert !(generate_user_agent.include? "Android")
      # if os is default then device_type is 'desktop'
    end
  end

  def test_all_device_types
    50.times do
      generate_user_agent(device_type: "all")
    end
  end

  def test_dev_type_smartphone_chrome
    50.times do
      assert_includes(generate_user_agent(device_type: "smartphone", navigator: "chrome"), "Mobile")
      assert_includes(generate_user_agent(device_type: "tablet", navigator: "chrome"), "Mobile")
    end
  end

  def test_random_ua_from_file
    50.times do
      assert_includes(random_ua(device_type: "smartphone"), "Mobile")
      assert_includes(random_ua(device_type: "tablet"), "Mobile")
      assert_includes(random_ua(device_type: "mobile"), "Mobile")
      assert_includes(random_ua(device_type: "desktop"), "Mozilla/5.0")
      assert !(random_ua.include? "Mobile")
    end
  end
end
