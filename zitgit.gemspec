# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'zitgit/version'

Gem::Specification.new do |spec|
  spec.name          = "zitgit"
  spec.version       = Zitgit::VERSION
  spec.authors       = ["Oleg Potapov"]
  spec.email         = ["oleg0potapov@gmail.com"]
  spec.description   = %q{Simple sinatra-based web-interface to view git repository history}
  spec.summary       = %q{Simple sinatra-based web-interface to view git repository history}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'sinatra'
  spec.add_dependency 'slim'
  spec.add_dependency 'compass'
  spec.add_dependency 'zurb-foundation', '=3.2.5'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'rb-readline'
  spec.add_development_dependency 'pry'
end
