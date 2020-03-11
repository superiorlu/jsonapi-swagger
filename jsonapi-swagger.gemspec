# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jsonapi/swagger/version'

Gem::Specification.new do |spec|
  spec.name          = 'jsonapi-swagger'
  spec.version       = Jsonapi::Swagger::VERSION
  spec.authors       = ['YingRui Lu']
  spec.email         = ['yingruilu518@gmail.com']

  spec.summary       = 'JSON API Swagger Doc Generator'
  spec.homepage      = 'https://github.com/superiorlu/jsonapi-swagger'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir['lib/**/*', 'LICENSE.md', 'README.md']
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.licenses      = ['MIT']

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '>= 12.3.3'
  spec.add_development_dependency 'rubocop', '~> 0.67'
  spec.add_development_dependency 'rswag', '~>2.0'
end
