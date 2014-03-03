# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'galago/router/version'

Gem::Specification.new do |spec|
  spec.name          = "galago-router"
  spec.version       = Galago::Router::VERSION
  spec.authors       = ["Joe Karayusuf"]
  spec.email         = ["jkarayusuf@gmail.com"]
  spec.description   = %q{Rack router}
  spec.summary       = %q{}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'rack'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
