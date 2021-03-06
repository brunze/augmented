# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'augmented/version'

Gem::Specification.new do |spec|
  spec.name          = "augmented"
  spec.version       = Augmented::VERSION
  spec.authors       = ["brunze"]
  spec.summary       = %q{Useful extra methods for some Ruby core types.}
  spec.description   = %q{Adds a few useful extra methods to some of Ruby's core types, available as refinements.}
  spec.homepage      = "https://github.com/brunze/augmented"
  spec.license       = "MIT"

  spec.metadata['homepage_uri']    = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri']   = spec.homepage + '/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = 'bin'
  spec.require_paths = ['lib']

  spec.add_development_dependency "bundler", "~> 2"
  spec.add_development_dependency "rake", ">= 13.0.3"
end
