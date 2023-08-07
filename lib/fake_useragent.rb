# frozen_string_literal: true

require_relative "fake_useragent/core"
#
# Generates a user agent string based on the specified operating system, navigator, platform, and device type.
#
# @param os [String, nil] The operating system for the user agent.
# @param navigator [String, nil] The web browser (navigator) for the user agent.
# @param platform [String, nil] The platform for the user agent.
# @param device_type [String, nil] The device type for which to generate the user agent.
#   Valid values are 'desktop', 'mobile', 'tablet', or 'smartphone'.
#
# @return [String] The generated user agent string.
#
def generate_user_agent(os: nil, navigator: nil, platform: nil, device_type: nil)
  Core.generate_navigator(os:, navigator:, platform:, device_type:)['user_agent']
end
#
# Generates navigator information based on the specified operating system, navigator, platform, and device type.
#
# @param os [String, nil] The operating system for the navigator.
# @param navigator [String, nil] The web browser (navigator) for the navigator.
# @param platform [String, nil] The platform for the navigator.
# @param device_type [String, nil] The device type for which to generate the navigator information.
#   Valid values are 'desktop', 'mobile', 'tablet', or 'smartphone'.
#
# @return [Hash] A hash containing various navigator details such as appCodeName, appName, appVersion, etc.
#
def generate_navigator_js(os: nil, navigator: nil, platform: nil, device_type: nil)
  config = Core.generate_navigator(os:, navigator:, platform:, device_type:)
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
    'buildID' => config['build_id'],
  }
end
# Generates a random user agent string based on the specified device type.
#
# @param device_type [String, nil] The device type for which to generate the user agent.
#   Valid values are `desktop`, `mobile`, `tablet`, or `smartphone`.
#
# @return [String] The randomly generated user agent string.
#
def random_ua(device_type: nil)
  Core.random_ua(device_type:)
end
