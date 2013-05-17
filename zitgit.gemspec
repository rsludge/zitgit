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
  spec.summary       = %q{Git repository viewer}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'sinatra', "~> 1.4"
  spec.add_dependency 'slim', "~> 1.3"
  spec.add_dependency 'gitlab-grit', "~> 2.5.1"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'guard', "~> 1.8"
  spec.add_development_dependency 'guard-sass', "~> 1.0"
  spec.add_development_dependency 'guard-coffeescript', "~> 1.3"
  spec.add_development_dependency 'therubyracer', "~> 0.11"
  spec.add_development_dependency 'rb-readline', "~> 0.4"
end
