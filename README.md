# Fake User Agent

[![Gem Version](https://badge.fury.io/rb/fake_useragent.svg)](https://badge.fury.io/rb/fake_useragent)

## Overview

Fake User Agent is a simple gem used for generating random valid web user agents. The user agent is a part of HTTP headers and the window.navigator JS object.

## Installation

To install the gem, use the following command:

```text
gem install fake_useragent
```

## Usage

You can generate user agents using the `generate_user_agent`, `generate_navigator_js` or `random_ua` methods. You can provide parameters such as `os`, `navigator`, `device_type`, and `platform` (deprecated) to customize the user agent. These parameters accept strings or arrays of strings for various combinations.

Here are some usage examples:

```ruby
generate_user_agent(os: %w[win linux])
# → "Mozilla/5.0 (X11; Linux; i686 on x86_64) AppleWebKit/537.36 (KHTML, like Gecko) ..."

generate_user_agent(os: %w[win linux], device_type: 'all')
# → "Mozilla/5.0 (Windows NT 6.3; ; rv:45.0) Gecko/20100101 Firefox/45.0"

generate_user_agent(device_type: %w[smartphone tablet], navigator: 'chrome')
# → "Mozilla/5.0 (Linux; Android 4.4.1; Lenovo S850 Build/KOT49H) AppleWebKit/537.36 ..."

generate_navigator_js
# → {"appCodeName"=>"Mozilla",
# "appName"=>"Netscape",
# "appVersion"=>"5.0 (Macintosh)",
# "platform"=>"MacIntel",
# "userAgent"=>
#  "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:48.0) Gecko/20100101 Firefox/48.0",
# "oscpu"=>"Intel Mac OS X 10.10",
# "product"=>"Gecko",
# "productSub"=>"20100101",
# "vendor"=>"",
# "vendorSub"=>"",
# "buildID"=>"20160808222632"}

random_ua
# Mozilla/5.0 (Macintosh; Intel Mac OS X 11_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100...

random_ua(device_type: 'mobile')
#
```

## [Changelog](https://github.com/TRT360/fake_useragent/blob/main/CHANGELOG.md)
