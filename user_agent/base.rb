#! /usr/bin/env ruby
# frozen_string_literal: true

require 'securerandom'
require 'time'

require_relative './error'

private

DEVICE_TYPE_OS = {
  'desktop' => %w[win mac linux],
  'smartphone' => ['android'],
  'tablet' => ['android']
}.freeze
OS_DEVICE_TYPE = {
  'win' => ['desktop'],
  'linux' => ['desktop'],
  'mac' => ['desktop'],
  'android' => %w[smartphone tablet]
}.freeze
DEVICE_TYPE_NAVIGATOR = {
  'desktop' => %w[chrome firefox ie],
  'smartphone' => %w[firefox chrome],
  'tablet' => %w[firefox chrome]
}.freeze
NAVIGATOR_DEVICE_TYPE = {
  'ie' => ['desktop'],
  'chrome' => %w[desktop smartphone tablet],
  'firefox' => %w[desktop smartphone tablet]
}.freeze
OS_PLATFORM = {
  'win' => [
    'Windows NT 5.1', # Windows XP
    'Windows NT 6.1', # Windows 7
    'Windows NT 6.2', # Windows 8
    'Windows NT 6.3', # Windows 8.1
    'Windows NT 10.0' # Windows 10
  ],
  'mac' => [
    'Macintosh; Intel Mac OS X 10.8',
    'Macintosh; Intel Mac OS X 10.9',
    'Macintosh; Intel Mac OS X 10.10',
    'Macintosh; Intel Mac OS X 10.11',
    'Macintosh; Intel Mac OS X 10.12'
  ],
  'linux' => [
    'X11; Linux',
    'X11; Ubuntu; Linux'
  ],
  'android' => [
    'Android 4.4', # 2013-10-31
    'Android 4.4.1', # 2013-12-05
    'Android 4.4.2', # 2013-12-09
    'Android 4.4.3', # 2014-06-02
    'Android 4.4.4', # 2014-06-19
    'Android 5.0', # 2014-11-12
    'Android 5.0.1', # 2014-12-02
    'Android 5.0.2', # 2014-12-19
    'Android 5.1', # 2015-03-09
    'Android 5.1.1', # 2015-04-21
    'Android 6.0', # 2015-10-05
    'Android 6.0.1', # 2015-12-07
    'Android 7.0', # 2016-08-22
    'Android 7.1', # 2016-10-04
    'Android 7.1.1' # 2016-12-05
  ]
}.freeze
OS_CPU = {
  'win' => [
    '', # 32bit
    'Win64; x64', # 64bit
    'WOW64' # 32bit process on 64bit system
  ],
  'linux' => [
    'i686', # 32bit
    'x86_64', # 64bit
    'i686 on x86_64' # 32bit process on 64bit system
  ],
  'mac' => [
    ''
  ],
  'android' => [
    'armv7l', # 32bit
    'armv8l' # 64bit
  ]
}.freeze
OS_NAVIGATOR = {
  'win' => %w[chrome firefox ie],
  'mac' => %w[firefox chrome],
  'linux' => %w[chrome firefox],
  'android' => %w[firefox chrome]
}.freeze
NAVIGATOR_OS = {
  'chrome' => %w[win linux mac android],
  'firefox' => %w[win linux mac android],
  'ie' => ['win']
}.freeze
FIREFOX_VERSION = [
  ['45.0', Time.new(2016, 3, 8)],
  ['46.0', Time.new(2016, 4, 26)],
  ['47.0', Time.new(2016, 6, 7)],
  ['48.0', Time.new(2016, 8, 2)],
  ['49.0', Time.new(2016, 9, 20)],
  ['50.0', Time.new(2016, 11, 15)],
  ['51.0', Time.new(2017, 1, 24)]
].freeze

# Top chrome builds from website access log
# for september, october 2020
CHROME_BUILD = '80.0.3987.132
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
'.strip.split(/\n+/)

IE_VERSION = [
  # [numeric ver, string ver, trident ver] # release year
  [8, 'MSIE 8.0', '4.0'], # 2009
  [9, 'MSIE 9.0', '5.0'], # 2011
  [10, 'MSIE 10.0', '6.0'], # 2012
  [11, 'MSIE 11.0', '7.0'] # 2013
].freeze
MACOSX_CHROME_BUILD_RANGE = {
  # https://en.wikipedia.org/wiki/MacOS#Release_history
  '10.8' => [0, 8],
  '10.9' => [0, 5],
  '10.10' => [0, 5],
  '10.11' => [0, 6],
  '10.12' => [0, 2]
}.freeze

def user_agent_template(tpl_name, system, app)
  case tpl_name
  when 'firefox'
    "Mozilla/5.0 (#{system['ua_platform']}; rv:#{app['build_version']}) Gecko/#{app['gecko_trail']} Firefox/#{app['build_version']}"
  when 'chrome'
    "Mozilla/5.0 (#{system['ua_platform']}) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/#{app['build_version']} Safari/537.36"
  when 'chrome_smartphone'
    "Mozilla/5.0 (#{system['ua_platform']}) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/#{app['build_version']} Mobile Safari/537.36"
  when 'chrome_tablet'
    "Mozilla/5.0(#{system['ua_platform']}) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/#{app['build_version']} Safari/537.36"
  when 'ie_less_11'
    "Mozilla/5.0 (compatible; #{app['build_version']}; #{system['ua_platform']}; Trident/#{app['trident_version']})"
  when 'ie_11'
    "Mozilla/5.0 (#{system['ua_platform']}; Trident/#{app['trident_version']}; rv: 11.0) like Gecko"
  end
end

def firefox_build
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

  [build_ver, build_rnd_time.strftime('%y%m%d%H%M%S')]
end

def chrome_build
  CHROME_BUILD.sample
end

def ie_build
  IE_VERSION.sample
end

def fix_chrome_mac_platform(platform)
  ver = platform.split('OS X ')[1]
  build_range = 0...MACOSX_CHROME_BUILD_RANGE[ver][1]
  build = rand(build_range)
  mac_version = "#{ver.sub('.', '_')}_#{build}"

  "Macintosh; Intel Mac OS X #{mac_version}"
end

def build_system_components(device_type, os_id, navigator_id)
  case os_id
  when 'win'
    platform_version = OS_PLATFORM['win'].sample.to_s
    cpu = OS_CPU['win'].sample
    platform = if cpu
                 "#{platform_version}; #{cpu}"
               else
                 platform_version.to_s
               end
    res = {
      'platform_version' => platform_version,
      'platform' => platform,
      'ua_platform' => platform,
      'os_cpu' => platform
    }
  when 'linux'
    cpu = OS_CPU['linux'].sample
    platform_version = OS_PLATFORM['linux'].sample
    platform = "#{platform_version}; #{cpu}"
    res = {
      'platform_version' => platform_version,
      'platform' => platform,
      'ua_platform' => platform,
      'os_cpu' => "Linux #{cpu}"
    }
  when 'mac'
    cpu = OS_CPU['mac'].sample
    platform_version = OS_PLATFORM['mac'].sample
    platform = platform_version
    platform = fix_chrome_mac_platform(platform) if navigator_id == 'chrome'
    res = {
      'platform_version' => platform_version.to_s,
      'platform' => 'MacIntel',
      'ua_platform' => platform.to_s,
      'os_cpu' => "Intel Mac OS X #{platform.split(' ')[-1]}"
    }
  when 'android'
    raise "#{navigator_id} not firefox or chrome" unless %w[firefox chrome].include? navigator_id
    raise "#{device_type} not smartphone or tablet" unless %w[smartphone tablet].include? device_type

    platform_version = OS_PLATFORM['android'].sample
    case navigator_id
    when 'firefox'
      case device_type
      when 'smartphone'
        ua_platform = "#{platform_version}; Mobile"
      when 'tablet'
        ua_platform = "#{platform_version}; Tablet"
      end
    when 'chrome'
      device_id = SMARTPHONE_DEV_IDS.sample
      ua_platform = "Linux; #{platform_version}; #{device_id}"
    end
    os_cpu = "Linux #{OS_CPU['android'].sample}"
    res = {
      'platform_version' => platform_version,
      'ua_platform' => ua_platform,
      'platform' => os_cpu,
      'os_cpu' => os_cpu
    }
  end
  res
end

def build_app_components(os_id, navigator_id)
  case navigator_id
  when 'firefox'
    build_version, build_id = firefox_build
    gecko_trail = if %w[win linux mac].include? os_id
                    '20100101'
                  else
                    build_version
                  end
    res = {
      'name' => 'Netscape',
      'product_sub' => '20100101',
      'vendor' => '',
      'build_version' => build_version,
      'build_id' => build_id,
      'gecko_trail' => gecko_trail
    }
  when 'chrome'
    res = {
      'name' => 'Netscape',
      'product_sub' => '20030107',
      'vendor' => 'Google Inc.',
      'build_version' => chrome_build,
      'build_id' => ''
    }
  when 'ie'
    num_ver, build_version, trident_version = ie_build
    app_name = if num_ver >= 11
                 'Netscape'
               else
                 'Microsoft Internet Explorer'
               end
    res = {
      'name' => app_name,
      'product_sub' => '',
      'vendor' => '',
      'build_version' => build_version.to_s,
      'build_id' => '',
      'trident_version' => trident_version
    }
  end
  res
end

def option_choices(opt_title, opt_value, default_value, all_choices)
  choices = []
  if opt_value.instance_of? String
    choices = [opt_value]
  elsif opt_value.instance_of? Array
    choices = opt_value
  elsif opt_value.nil?
    choices = default_value
  else
    raise InvalidOption "Option #{opt_title} has invalid value: #{opt_value}"
  end

  choices = all_choices if choices.include? 'all'

  choices.each do |item|
    raise InvalidOption "Choices of option #{opt_title} contains invalid item: #{item}" unless all_choices.include? item
  end
  choices
end

def pick_config_ids(device_type, os, navigator)
  default_dev_types = if os.nil?
                        ['desktop']
                      else
                        DEVICE_TYPE_OS.keys
                      end
  dev_type_choices = option_choices(
    'device_type',
    device_type,
    default_dev_types,
    DEVICE_TYPE_OS.keys
  )
  os_choices = option_choices(
    'os',
    os,
    OS_NAVIGATOR.keys,
    OS_NAVIGATOR.keys
  )
  navigator_choices = option_choices(
    'navigator',
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

  raise InvalidOption 'Options device_type, os and navigator conflicts with each other' if variants.nil?

  device_type, os_id, navigator_id = variants.sample

  raise 'os_id not in OS_PLATFORM' unless OS_PLATFORM.include? os_id
  raise 'navigator_id not in NAVIGATOR_OS' unless NAVIGATOR_OS.include? navigator_id
  raise 'navigator_id not in DEVICE_TYPE_IDS' unless DEVICE_TYPE_OS.include? device_type

  [device_type, os_id, navigator_id]
end

def choose_ua_template(device_type, navigator_id, app, sys)
  tpl_name = navigator_id
  case navigator_id
  when 'ie'
    tpl_name = if app['build_version'] == 'MSIE 11.0'
                 'ie_11'
               else
                 'ie_less_11'
               end
  when 'chrome'
    tpl_name = case device_type
               when 'smartphone'
                 'chrome_smartphone'
               when 'tablet'
                 'chrome_tablet'
               else
                 'chrome'
               end
  end
  user_agent_template(tpl_name, sys, app)
end

def build_navigator_app_version(os_id, navigator_id, platform_version, user_agent)
  if %w[chrome ie].include? navigator_id
    raise 'User agent doesn\'t start with "Mozilla/"' unless user_agent.to_s.start_with? 'Mozilla/'

    app_version = user_agent.split('Mozilla/')[1]
  elsif navigator_id == 'firefox'
    if os_id == 'android'
      app_version = "5.0 (#{platform_version})"
    else
      os_token = {
        'win' => 'Windows',
        'mac' => 'Macintosh',
        'linux' => 'X11'
      }[os_id]
      app_version = "5.0 (#{os_token})"
    end
  end
  app_version
end

def generate_navigator(os: nil, navigator: nil, platform: nil, device_type: nil)
  if !platform.nil?
    os = platform
    warn('The `platform` version is deprecated. Use `os` option instead', uplevel: 3)
  end
  device_type, os_id, navigator_id = pick_config_ids(device_type, os, navigator)
  sys = build_system_components(device_type, os_id, navigator_id)
  app = build_app_components(os_id, navigator_id)
  user_agent = choose_ua_template(device_type, navigator_id, app, sys)
  app_version = build_navigator_app_version(
    os_id, navigator_id, sys['platform_version'], user_agent
  )
  {
    'os_id' => os_id,
    'navigator_id' => navigator_id,
    'platform' => sys['platform'],
    'os_cpu' => sys['os_cpu'],
    'build_version' => app['build_version'],
    'build_id' => app['build_id'],
    'app_version' => app_version,
    'app_name' => app['name'],
    'app_code_name' => 'Mozilla',
    'product' => 'Gecko',
    'product_sub' => app['product_sub'],
    'vendor' => app['vendor'],
    'vendor_sub' => '',
    'user_agent' => user_agent
  }
end

public

def generate_user_agent(os: nil, navigator: nil, platform: nil, device_type: nil)
  generate_navigator(os: os, navigator: navigator, platform: platform, device_type: device_type)['user_agent']
end

def generate_navigator_js(os: nil, navigator: nil, platform: nil, device_type: nil)
  config = generate_navigator(os, navigator, platform, device_type)
  {
    'appCodeName' => config['app_code_name'],
    'appName' => config['app_name'],
    'appVersion' => config['app_version'],
    'platform' => config['platform'],
    'userAgent' => config['user_agent'],
    'os_cpu' => config['os_cpu'],
    'product' => config['product'],
    'productSub' => config['product_sub'],
    'vendor' => config['vendor'],
    'vendorSub' => config['vendor_sub'],
    'buildID' => config['build_id']
  }
end

generate_user_agent(os: 11)
