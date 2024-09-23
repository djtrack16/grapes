#encoding: utf-8
#lib = File.expand_path('../lib', __FILE__)
#$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'grapes/version'

Gem::Specification.new do |spec|
  spec.name          = "grapes"
  spec.version       = Grapes::VERSION
  spec.authors       = ["Darius Liddell"]
  spec.email         = ["djtrack16@gmail.com"]

  spec.summary       = "Tool for scraping and organizing wine grape data from government websites"
  spec.description   = ""#%q{}
  #spec.homepage      = "https://github.com/kueda/casento"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  #spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  #spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.8"
  spec.add_development_dependency "m", "~> 1.4"
  spec.add_runtime_dependency 'nokogiri', "~> 1.6"
  spec.add_runtime_dependency 'activesupport', "~> 4.2"
  spec.add_runtime_dependency 'commander', "~> 4.3"
end
