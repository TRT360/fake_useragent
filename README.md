# Fake User Agent

## For what?
Generates random valid web user agents

## Installation
`gem install fake_useragent`

## Usage example:
This version just a test. You can use `generate_user_agent`, or `generate_navigator_js`

parameters: `os`, `navigator`, `device_type` and `platform` (deprecated)  
Possible values:  
`os`: `win`, `linux`, `mac`  
`navigator`: `ie`, `chrome` or `firefox`  
`device_type`: `desktop`, `smartphone`, `tablet` or `all`  
Keep in mind array combinations are possible.
```ruby
generate_user_agent(os: %w[win linux])
# → "Mozilla/5.0 (X11; Linux; i686 on x86_64) AppleWebKit/537.36 (KHTML, like Gecko) ..."

generate_user_agent(os: %w[win linux], device_type: 'all')
# → "Mozilla/5.0 (Windows NT 6.3; ; rv:45.0) Gecko/20100101 Firefox/45.0"

generate_user_agent(device_type: %w[smartphone tablet], navigator: 'chrome')
# → "Mozilla/5.0 (Linux; Android 4.4.1; Lenovo S850 Build/KOT49H) AppleWebKit/537.36 ..."

generate_navigator_js # 
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
```

