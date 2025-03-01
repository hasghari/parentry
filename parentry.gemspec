lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'parentry/version'

Gem::Specification.new do |spec|
  spec.name          = 'parentry'
  spec.version       = Parentry::VERSION
  spec.authors       = ['Hamed Asghari']
  spec.email         = ['hasghari@gmail.com']

  spec.summary       = 'ActiveRecord adapter for the Postgres ltree module'
  spec.homepage      = 'https://github.com/hasghari/parentry'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 3.2'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.add_dependency 'activerecord', '>= 7.1', '< 8.1'
end
