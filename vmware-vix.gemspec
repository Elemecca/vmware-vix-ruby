# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vmware/vix/version'

Gem::Specification.new do |spec|
  spec.name          = "vmware-vix"
  spec.version       = VMware::Vix::VERSION
  spec.authors       = ["Sam Hanes"]
  spec.email         = ["sam@maltera.com"]
  spec.licenses      = ['Apache-2.0', 'CC0-1.0']

  spec.summary       = %q{FFI binding for VMware VIX, plus abstraction.}
  spec.homepage      = "https://github.com/Elemecca/vmware-vix-ruby"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_runtime_dependency "ffi", "~> 1.9"
end
