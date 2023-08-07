# frozen_string_literal: true

require "time"
require "json"

require_relative "error"
require_relative "device"

module Core
  DEVICE_TYPE_OS = {
    "desktop" => %w[win mac linux],
    "smartphone" => %w[android],
    "tablet" => %w[android],
  }.freeze

  OS_DEVICE_TYPE = {
    "win" => %w[desktop],
    "linux" => %w[desktop],
    "mac" => %w[desktop],
    "android" => %w[smartphone tablet],
  }.freeze

  DEVICE_TYPE_NAVIGATOR = {
    "desktop" => %w[chrome firefox],
    "smartphone" => %w[firefox chrome],
    "tablet" => %w[firefox chrome],
  }.freeze

  NAVIGATOR_DEVICE_TYPE = {
    "chrome" => %w[desktop smartphone tablet],
    "firefox" => %w[desktop smartphone tablet],
  }.freeze

  OS_PLATFORM = {
    "win" => [
      "Windows NT 5.1", # Windows XP
      "Windows NT 6.1", # Windows 7
      "Windows NT 6.2", # Windows 8
      "Windows NT 6.3", # Windows 8.1
      "Windows NT 10.0", # Windows 10
      "Windows NT 11.0", # Windows 11
    ],
    "mac" => [
      "Macintosh; Intel Mac OS X 10.8",
      "Macintosh; Intel Mac OS X 10.9",
      "Macintosh; Intel Mac OS X 10.10",
      "Macintosh; Intel Mac OS X 10.11",
      "Macintosh; Intel Mac OS X 10.12",
      "Macintosh; Intel Mac OS X 10.13",
      "Macintosh; Intel Mac OS X 10.14",
      "Macintosh; Intel Mac OS X 10.15",
      "Macintosh; Intel Mac OS X 11",
      "Macintosh; Intel Mac OS X 11.2",
      "Macintosh; Intel Mac OS X 11.3",
      "Macintosh; Intel Mac OS X 11.5",
      "Macintosh; Intel Mac OS X 11.6",
      "Macintosh; Intel Mac OS X 11.7",
      "Macintosh; Intel Mac OS X 12",
      "Macintosh; Intel Mac OS X 12.2",
      "Macintosh; Intel Mac OS X 12.3",
      "Macintosh; Intel Mac OS X 12.5",
      "Macintosh; Intel Mac OS X 12.6",
      "Macintosh; Intel Mac OS X 13",
      "Macintosh; Intel Mac OS X 13.2",
      "Macintosh; Intel Mac OS X 13.3",
    ],
    "linux" => [
      "X11; Linux",
      "X11; Ubuntu; Linux",
    ],
    "android" => [
      "Android 7.0",   # 2016-08-22
      "Android 7.1",   # 2016-10-04
      "Android 7.1.1", # 2016-12-05
      "Android 7.1.2",
      "Android 8.0.0",
      "Android 8.1.0",
      "Android 9",
      "Android 10",
      "Android 11",
      "Android 12",
      "Android 13", # 2022-08-15
    ],
  }.freeze

  OS_CPU = {
    "win" => [
      "", # 32bit
      "Win64; x64", # 64bit
      "WOW64", # 32bit process on 64bit system
    ],
    "linux" => [
      "i686", # 32bit
      "x86_64", # 64bit
      "i686 on x86_64", # 32bit process on 64bit system
    ],
    "mac" => [
      "",
    ],
    "android" => [
      "armv7l", # 32bit
      "armv8l", # 64bit
      "arm_64",
    ],
  }.freeze

  OS_NAVIGATOR = {
    "win" => %w[chrome firefox],
    "mac" => %w[firefox chrome],
    "linux" => %w[chrome firefox],
    "android" => %w[firefox chrome],
  }.freeze

  NAVIGATOR_OS = {
    "chrome" => %w[win linux mac android],
    "firefox" => %w[win linux mac android],
  }.freeze

  # https://en.wikipedia.org/wiki/Firefox_version_history
  # Firefox \d+ (?:and Firefox \d+ ESR )?(?:was|were) released on (January|February|March|April|May|June|July|August|September|October|November|December) (\d+), (\d+)\.
  FIREFOX_VERSION = [
    ["60.0", Time.new(2018, 5, 9)],
    ["61.0", Time.new(2018, 6, 26)],
    ["62.0", Time.new(2018, 9, 5)],
    ["63.0", Time.new(2018, 10, 23)],
    ["65.0", Time.new(2019, 1, 29)],
    ["66.0", Time.new(2019, 3, 19)],
    ["67.0", Time.new(2019, 5, 21)],
    ["68.0", Time.new(2019, 7, 9)],
    ["69.0", Time.new(2019, 9, 3)],
    ["70.0", Time.new(2019, 10, 22)],
    ["71.0", Time.new(2019, 12, 3)],
    ["72.0", Time.new(2020, 1, 7)],
    ["73.0", Time.new(2020, 2, 11)],
    ["74.0", Time.new(2020, 3, 10)],
    ["75.0", Time.new(2020, 4, 7)],
    ["76.0", Time.new(2020, 5, 5)],
    ["77.0", Time.new(2020, 6, 2)],
    ["78.0", Time.new(2020, 6, 30)],
    ["79.0", Time.new(2020, 7, 28)],
    ["81.0", Time.new(2020, 9, 22)],
    ["82.0", Time.new(2020, 10, 20)],
    ["83.0", Time.new(2020, 11, 17)],
    ["84.0", Time.new(2020, 12, 15)],
    ["85.0", Time.new(2021, 1, 26)],
    ["86.0", Time.new(2021, 2, 23)],
    ["87.0", Time.new(2021, 3, 23)],
    ["88.0", Time.new(2021, 4, 19)],
    ["89.0", Time.new(2021, 6, 1)],
    ["90.0", Time.new(2021, 7, 13)],
    ["91.0", Time.new(2021, 8, 10)],
    ["92.0", Time.new(2021, 9, 7)],
    ["93.0", Time.new(2021, 10, 5)],
    ["94.0", Time.new(2021, 11, 2)],
    ["95.0", Time.new(2021, 12, 7)],
    ["96.0", Time.new(2022, 1, 11)],
    ["97.0", Time.new(2022, 2, 8)],
    ["98.0", Time.new(2022, 3, 8)],
    ["99.0", Time.new(2022, 4, 5)],
    ["100.0", Time.new(2022, 5, 3)],
    ["101.0", Time.new(2022, 5, 31)],
    ["104.0", Time.new(2022, 8, 23)],
    ["105.0", Time.new(2022, 9, 20)],
    ["106.0", Time.new(2022, 10, 18)],
    ["107.0", Time.new(2022, 11, 15)],
    ["108.0", Time.new(2022, 12, 13)],
    ["109.0", Time.new(2023, 1, 17)],
    ["110.0", Time.new(2023, 2, 14)],
    ["111.0", Time.new(2023, 3, 14)],
    ["112.0", Time.new(2023, 4, 11)],
    ["113.0", Time.new(2023, 5, 9)],
    ["114.0", Time.new(2023, 6, 6)],
    ["115.0", Time.new(2023, 7, 4)],
    ["116.0", Time.new(2023, 8, 1)],
  ]

  CHROME_BUILD = "80.0.3987.132
80.0.3987.149
80.0.3987.99
81.0.4044.117
81.0.4044.138
83.0.4103.101
83.0.4103.106
83.0.4103.96
84.0.4147.105
84.0.4147.111
84.0.4147.125
84.0.4147.135
84.0.4147.89
85.0.4183.101
85.0.4183.102
85.0.4183.120
85.0.4183.121
85.0.4183.127
85.0.4183.81
85.0.4183.83
86.0.4240.110
86.0.4240.111
86.0.4240.114
86.0.4240.183
86.0.4240.185
86.0.4240.75
86.0.4240.78
86.0.4240.80
86.0.4240.96
86.0.4240.99
108.0.5359.238
108.0.5359.239
114.0.5735.102
114.0.5735.110
114.0.5735.114
114.0.5735.143
114.0.5735.199
114.0.5735.239
115.0.5790.102
115.0.5790.110
115.0.5790.114
115.0.5790.130
115.0.5790.131
115.0.5790.136
115.0.5790.138
115.0.5790.160
115.0.5790.166
115.0.5790.170
115.0.5790.83
115.0.5790.85
115.0.5790.98
115.0.5790.99
116.0.5845.50
116.0.5845.51
116.0.5845.52
116.0.5845.60
116.0.5845.61
116.0.5845.62
".strip.split(/\n+/)

  MACOSX_CHROME_BUILD_RANGE = {
    # https://en.wikipedia.org/wiki/MacOS#Release_history
    "10.8" => [0, 8],
    "10.9" => [0, 5],
    "10.10" => [0, 5],
    "10.11" => [0, 6],
    "10.12" => [0, 6],
    "10.13" => [0, 6],
    "10.14" => [0, 6],
    "10.15" => [0, 7],
    "11" => [0, 7],
    "11.2" => [0, 3],
    "11.3" => [0, 1],
    "11.5" => [0, 2],
    "11.6" => [0, 8],
    "11.7" => [0, 9],
    "12" => [0, 6],
    "12.0" => [0, 1],
    "12.2" => [0, 1],
    "12.3" => [0, 1],
    "12.5" => [0, 1],
    "12.6" => [0, 8],
    "13" => [0, 5],
    "13.0" => [0, 1],
    "13.2" => [0, 1],
    "13.3" => [0, 1],
    "13.4" => [0, 1],
  }.freeze

  def self.user_agent_template(tpl_name, system, app)
    case tpl_name
    when "firefox"
      "Mozilla/5.0 (#{system["ua_platform"]}; rv:#{app["build_version"]}) Gecko/#{app["gecko_trail"]} Firefox/#{app["build_version"]}"
    when "chrome"
      "Mozilla/5.0 (#{system["ua_platform"]}) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/#{app["build_version"]} Safari/537.36"
    when "chrome_smartphone"
      "Mozilla/5.0 (#{system["ua_platform"]}) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/#{app["build_version"]} Mobile Safari/537.36"
    when "chrome_tablet"
      "Mozilla/5.0(#{system["ua_platform"]}) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/#{app["build_version"]} Mobile Safari/537.36"
    end
  end

  def self.firefox_build
    firefox_ver = FIREFOX_VERSION.sample
    build_ver = firefox_ver[0]
    date_from = firefox_ver[1].to_i

    begin
      idx = FIREFOX_VERSION.index(firefox_ver)
      date_to = FIREFOX_VERSION.fetch(idx + 1)[1].to_i
    rescue IndexError
      date_to = date_from + 86_399
    end
    sec_range = date_to - date_from
    build_rnd_time = Time.at(date_from + rand(sec_range))

    [build_ver, build_rnd_time.strftime("%Y%m%d%H%M%S")]
  end

  def self.chrome_build
    CHROME_BUILD.sample
  end

  def self.fix_chrome_mac_platform(platform)
    ver = platform.split("OS X ")[1]
    build_range = 0...MACOSX_CHROME_BUILD_RANGE[ver][1]
    build = rand(build_range)
    mac_version = "#{ver.sub(".", "_")}_#{build}"

    "Macintosh; Intel Mac OS X #{mac_version}"
  end

  def self.build_system_components(device_type, os_id, navigator_id)
    case os_id
    when "win"
      platform_version = OS_PLATFORM["win"].sample.to_s
      cpu = OS_CPU["win"].sample
      platform = if cpu
          "#{platform_version}; #{cpu}"
        else
          platform_version.to_s
        end
      res = {
        "platform_version" => platform_version,
        "platform" => platform,
        "ua_platform" => platform,
        "os_cpu" => platform,
      }
    when "linux"
      cpu = OS_CPU["linux"].sample
      platform_version = OS_PLATFORM["linux"].sample
      platform = "#{platform_version}; #{cpu}"
      res = {
        "platform_version" => platform_version,
        "platform" => platform,
        "ua_platform" => platform,
        "os_cpu" => "Linux #{cpu}",
      }
    when "mac"
      platform_version = OS_PLATFORM["mac"].sample
      platform = platform_version
      platform = fix_chrome_mac_platform(platform) if navigator_id == "chrome"
      res = {
        "platform_version" => platform_version.to_s,
        "platform" => "MacIntel",
        "ua_platform" => platform.to_s,
        "os_cpu" => "Intel Mac OS X #{platform.split(" ")[-1]}",
      }
    when "android"
      raise "#{navigator_id} not firefox or chrome" unless %w[firefox chrome].include? navigator_id
      raise "#{device_type} not smartphone or tablet" unless %w[smartphone tablet].include? device_type

      platform_version = OS_PLATFORM["android"].sample
      case navigator_id
      when "firefox"
        case device_type
        when "smartphone"
          ua_platform = "#{platform_version}; Mobile"
        when "tablet"
          ua_platform = "#{platform_version}; Tablet"
        end
      when "chrome"
        device_id = SMARTPHONE_DEV_IDS.sample
        ua_platform = "Linux; #{platform_version}; #{device_id}"
      end
      os_cpu = "Linux #{OS_CPU["android"].sample}"
      res = {
        "platform_version" => platform_version,
        "ua_platform" => ua_platform,
        "platform" => os_cpu,
        "os_cpu" => os_cpu,
      }
    end
    res
  end

  def self.build_app_components(os_id, navigator_id)
    case navigator_id
    when "firefox"
      build_version, build_id = firefox_build
      gecko_trail = if %w[win linux mac].include? os_id
          "20100101"
        else
          build_version
        end
      {
        "name" => "Netscape",
        "product_sub" => "20100101",
        "vendor" => "",
        "build_version" => build_version,
        "build_id" => build_id,
        "gecko_trail" => gecko_trail,
      }
    when "chrome"
      {
        "name" => "Netscape",
        "product_sub" => "20030107",
        "vendor" => "Google Inc.",
        "build_version" => chrome_build,
        "build_id" => "",
      }
    end
  end

  def self.option_choices(opt_title, opt_value, default_value, all_choices)
    choices = []
    if opt_value.instance_of? String
      choices = [opt_value]
    elsif opt_value.instance_of? Array
      choices = opt_value
    elsif opt_value.nil?
      choices = default_value
    else
      raise InvalidOption, "Option #{opt_title} has invalid value: #{opt_value}"
    end

    choices = all_choices if choices.include? "all"

    choices.each do |item|
      unless all_choices.include? item
        raise InvalidOption,
              "Choices of option #{opt_title} contains invalid item: #{item}"
      end
    end
    choices
  end

  def self.pick_config_ids(device_type, os, navigator)
    default_dev_types = if os.nil?
        ["desktop"]
      else
        DEVICE_TYPE_OS.keys
      end
    dev_type_choices = option_choices(
      "device_type",
      device_type,
      default_dev_types,
      DEVICE_TYPE_OS.keys
    )
    os_choices = option_choices(
      "os",
      os,
      OS_NAVIGATOR.keys,
      OS_NAVIGATOR.keys
    )
    navigator_choices = option_choices(
      "navigator",
      navigator,
      NAVIGATOR_OS.keys,
      NAVIGATOR_OS.keys
    )
    variants = []

    prod = dev_type_choices.product(os_choices, navigator_choices)
    prod.each do |dev, os_, nav|
      if (DEVICE_TYPE_OS[dev].include? os_) && (DEVICE_TYPE_NAVIGATOR[dev].include? nav) && (OS_NAVIGATOR[os_].include? nav)
        variants << [dev, os_, nav]
      end
    end

    raise InvalidOption "Options device_type, os and navigator conflicts with each other" if variants.nil?

    device_type, os_id, navigator_id = variants.sample

    unless OS_PLATFORM.include? os_id
      raise InvalidOption,
            "os_id not in OS_PLATFORM"
    end
    raise InvalidOption, "navigator_id not in NAVIGATOR_OS" unless NAVIGATOR_OS.include? navigator_id
    raise InvalidOption, "navigator_id not in DEVICE_TYPE_IDS" unless DEVICE_TYPE_OS.include? device_type

    [device_type, os_id, navigator_id]
  end

  def self.choose_ua_template(device_type, navigator_id, app, sys)
    tpl_name = navigator_id
    case navigator_id
    when "chrome"
      tpl_name = case device_type
        when "smartphone"
          "chrome_smartphone"
        when "tablet"
          "chrome_tablet"
        else
          "chrome"
        end
    end
    user_agent_template(tpl_name, sys, app)
  end

  def self.build_navigator_app_version(os_id, navigator_id, platform_version, user_agent)
    if %w[chrome].include? navigator_id
      raise "User agent doesn\'t start with 'Mozilla/'" unless user_agent.to_s.start_with? "Mozilla/"

      app_version = user_agent.split("Mozilla/")[1]
    elsif navigator_id == "firefox"
      if os_id == "android"
        app_version = "5.0 (#{platform_version})"
      else
        os_token = {
          "win" => "Windows",
          "mac" => "Macintosh",
          "linux" => "X11",
        }[os_id]
        app_version = "5.0 (#{os_token})"
      end
    end
    app_version
  end

  def self.generate_navigator(os: nil, navigator: nil, platform: nil, device_type: nil)
    unless platform.nil?
      os = platform
      warn("The `platform` version is deprecated. Use `os` option instead", uplevel: 3)
    end
    device_type, os_id, navigator_id = pick_config_ids(device_type, os, navigator)
    sys = build_system_components(device_type, os_id, navigator_id)
    app = build_app_components(os_id, navigator_id)
    user_agent = choose_ua_template(device_type, navigator_id, app, sys)
    app_version = build_navigator_app_version(
      os_id, navigator_id, sys["platform_version"], user_agent
    )
    {
      "os_id" => os_id,
      "navigator_id" => navigator_id,
      "platform" => sys["platform"],
      "os_cpu" => sys["os_cpu"],
      "build_version" => app["build_version"],
      "build_id" => app["build_id"],
      "app_version" => app_version,
      "app_name" => app["name"],
      "app_code_name" => "Mozilla",
      "product" => "Gecko",
      "product_sub" => app["product_sub"],
      "vendor" => app["vendor"],
      "vendor_sub" => "",
      "user_agent" => user_agent,
    }
  end

  def self.random_ua(device_type: nil)
    valid_device_types = %w[desktop mobile tablet smartphone]
    unless device_type.nil? || valid_device_types.include?(device_type.downcase)
      raise ArgumentError,
            "Invalid device type: #{device_type}. Expected one of #{valid_device_types.join(", ")}"
    end

    if ["desktop", nil].include? device_type
      DESKTOP_USERAGENTS.sample
    else
      MOBILE_USERAGENTS.sample
    end
  end

  private_class_method(
    :chrome_build,
    :user_agent_template,
    :build_navigator_app_version,
    :build_app_components,
    :build_system_components,
    :choose_ua_template,
    :pick_config_ids,
    :option_choices,
    :firefox_build,
    :fix_chrome_mac_platform
  )
  private_constant(
    :DEVICE_TYPE_OS,
    :NAVIGATOR_OS,
    :OS_PLATFORM,
    :OS_NAVIGATOR,
    :DEVICE_TYPE_NAVIGATOR,
    :OS_CPU,
    :MACOSX_CHROME_BUILD_RANGE,
    :CHROME_BUILD,
    :NAVIGATOR_DEVICE_TYPE,
    :OS_DEVICE_TYPE
  )
end
