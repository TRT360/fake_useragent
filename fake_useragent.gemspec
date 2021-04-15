$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name = 'fake_useragent'
  s.version     = '1.0.0'
  s.date        = '2021-04-17'
  s.summary     = 'FakeUserAgent - simple gem for generating valid web user agents.'
  s.description = 'Simple gem for generating valid web user agents.'
  s.author      = 'Bokanov Alexander'
  s.email       = 'overhead.nerves@gmail.com'
  s.homepage    = 'https://github.com/TRT360/fake_useragent'
  s.license     = 'MIT'
  s.files       = `git ls-files`.split("\n")
  s.add_dependency('test/unit')
end