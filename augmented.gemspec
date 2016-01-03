# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'augmented/version'

Gem::Specification.new do |spec|
  spec.name          = "augmented"
  spec.version       = Augmented::VERSION
  spec.authors       = ["bruno"]
  spec.email         = ["bruno@brunze.com"]
  spec.summary       = %q{Useful extra methods for some Ruby core types.}
  spec.description   = %q{Adds a few useful extra methods to some of Ruby's core types, available as refinements.}
  spec.homepage      = "https://github.com/brunze/augmented"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
