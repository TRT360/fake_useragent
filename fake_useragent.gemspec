# frozen_string_literal: true

require_relative "lib/fake_useragent/version"

Gem::Specification.new do |spec|
  spec.name = "fake_useragent"
  spec.version = FakeUserAgent::VERSION
  spec.date = "2023-08-07"
  spec.summary = "FakeUserAgent - A simple gem for generating valid web user agents."
  spec.description = "Simple gem used for generating random valid web user agents."
  spec.authors = ["Bokanov Alexander"]
  spec.email = "overhead.nerves@gmail.com"
  spec.homepage = "https://github.com/TRT360/fake_useragent"
  spec.license = "MIT"
  spec.files = Dir["{lib}/**/*", "LICENSE.txt", "README.md"]
  spec.required_ruby_version = ">= 2.7.2"
  spec.metadata = {
    "source_code_uri" => "https://github.com/TRT360/fake_useragent",
    "changelog_uri" => "https://github.com/TRT360/fake_useragent/blob/main/CHANGELOG.md",
  }
end
