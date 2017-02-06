# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'yakc/version'

Gem::Specification.new do |spec|
  spec.name          = "yakc"
  spec.version       = Yakc::VERSION
  spec.authors       = ["Greg"]
  spec.email         = ["greg@avvo.com"]

  spec.summary       = "Multitopic Poseidon-base Kafaka consumer"
  spec.homepage      = "http://www.github.com/gaorlov/yakc"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "poseidon_cluster", "0.3.2.avvo3"
  spec.add_dependency "activesupport"

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "simplecov"
end
