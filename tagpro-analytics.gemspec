# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tagpro/analytics/version'

Gem::Specification.new do |spec|
	spec.name          = "tagpro-analytics"
	spec.version       = Tagpro::Analytics::VERSION
	spec.authors       = ["Kera", "Ronding"]
	spec.email         = ["keratagpro@gmail.com"]
	spec.summary       = %q{Ruby port of Ronding's TagPro Analytics readers.}
	spec.description   = %q{Utilities for parsing TagPro Analytics match files.}
	spec.homepage      = "https://github.com/keratagpro/tagpro-analytics-ruby"
	spec.license       = "MIT"

	spec.files         = `git ls-files -z`.split("\x0")
	spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
	spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
	spec.require_paths = ["lib"]

	spec.add_dependency 'wisper'
	
	spec.add_development_dependency "bundler", "~> 1.7"
	spec.add_development_dependency "rake", "~> 10.0"
end
