# frozen_string_literal: true
require_relative './fake_useragent/core'

def generate_user_agent(os: nil, navigator: nil, platform: nil, device_type: nil)
  generate_navigator(os: os, navigator: navigator, platform: platform, device_type: device_type)['user_agent']
end

def generate_navigator_js(os: nil, navigator: nil, platform: nil, device_type: nil)
  config = generate_navigator(os: os, navigator: navigator, platform: platform, device_type: device_type)
  {
    'appCodeName' => config['app_code_name'],
    'appName' => config['app_name'],
    'appVersion' => config['app_version'],
    'platform' => config['platform'],
    'userAgent' => config['user_agent'],
    'oscpu' => config['os_cpu'],
    'product' => config['product'],
    'productSub' => config['product_sub'],
    'vendor' => config['vendor'],
    'vendorSub' => config['vendor_sub'],
    'buildID' => config['build_id']
  }
end