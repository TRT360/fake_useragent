# Fake User Agent
## What is it for?
Generates random valid web user agents

## Usage
This version just a test. You can use `generate_user_agent` or `generate_navigator_js` from `base.rb`.  
Example:
```ruby
generate_user_agent(os: 'win', navigator: 'chrome') 
# → "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.101 Safari/537.36"

generate_navigator_js(os: 'win', navigator: 'chrome')
# → {"appCodeName"=>"Mozilla", "appName"=>"Netscape",..}
```
parameters: `os`, `navigator`, `device_type` and `platform` (deprecated)  
`os` may be win, linux or mac  
`navigator` only ie, chrome or firefox  
`device_type` only desktop, smartphone or tablet  

