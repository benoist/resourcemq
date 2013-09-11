# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'resource_mq/version'

Gem::Specification.new do |spec|
  spec.name          = "resource_mq"
  spec.version       = ResourceMQ::VERSION
  spec.authors       = ["Benoist"]
  spec.email         = ["benoist.claassen@gmail.com"]
  spec.description   = %q{TODO: Write a gem description}
  spec.summary       = %q{TODO: Write a gem summary}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", "~> 4.0"
  spec.add_dependency "activemodel", "~> 4.0"
  spec.add_dependency "virtus", "~> 0.5"
  spec.add_dependency "ffi-rzmq", "~> 0.5"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "minitest", "~> 4.7"
  spec.add_development_dependency "minitest-reporters"
  spec.add_development_dependency "rake"
end
