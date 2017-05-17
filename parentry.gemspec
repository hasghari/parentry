# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'parentry/version'

Gem::Specification.new do |spec|
  spec.name          = 'parentry'
  spec.version       = Parentry::VERSION
  spec.authors       = ['Hamed Asghari']
  spec.email         = ['hasghari@gmail.com']

  spec.summary       = %q{ActiveRecord adapter for the Postgres ltree module}
  spec.homepage      = 'https://github.com/hasghari/parentry'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activerecord', '~> 5.1'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec-rails', '~> 3.6'
  spec.add_development_dependency 'pg', '~> 0.20'
  spec.add_development_dependency 'combustion', '0.5.3'
  spec.add_development_dependency 'database_cleaner', '~> 1.6'
  spec.add_development_dependency 'pry', '~> 0.10'
end
