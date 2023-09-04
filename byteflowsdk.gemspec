Gem::Specification.new do |s|
  s.name        = "byteflowsdk"
  s.version     = "1.0.2"
  s.summary     = "SDK For Byteflow"
  s.description = "Official SDK for Byteflow (https://byteflow.app). Docs: https://docs.byteflow.app"
  s.authors     = ["Max Campbell"]
  s.files       = ["lib/byteflowsdk.rb"]
  s.homepage    =
    "https://rubygems.org/gems/byteflowsdk"
  s.license       = "MIT"

  # Dependencies
  s.add_dependency "faraday", ">= 0.9", "< 3.0"
  s.add_dependency "faraday-retry", ">= 0.9", "< 3.0"
end
