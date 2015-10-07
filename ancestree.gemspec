# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ancestree/version'

Gem::Specification.new do |spec|
  spec.name          = 'ancestree'
  spec.version       = Ancestree::VERSION
  spec.authors       = ['Hamed Asghari']
  spec.email         = ['hasghari@gmail.com']

  spec.summary       = %q{ActiveRecord adapter for the Postgres ltree module}
  spec.homepage      = 'https://github.com/hasghari/ancestree'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
end
