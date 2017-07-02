# -*- encoding: utf-8 -*-

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "current_attributes/version"

Gem::Specification.new do |spec|
  spec.name          = "rails-current-attributes"
  spec.version       = CurrentAttributes::VERSION
  spec.authors       = ["David Heinemeier Hansson"]
  spec.email         = ["david@loudthinking.com"]
  spec.description   = %q{ Provides a thread-isolated attributes singleton. }
  spec.summary       = %q{ Provides a thread-isolated attributes singleton. }
  spec.homepage      = "https://github.com/ahazem/rails-current-attributes"
  spec.license       = "MIT"

  spec.files         = Dir["LICENSE.txt", "README.md", "lib/**/*"]
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "activesupport", "~> 5.0"

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
