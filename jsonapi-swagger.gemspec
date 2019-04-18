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

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
 end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir['lib/**/*', 'LICENSE.md', 'README.md']
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.licenses      = ['MIT']

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rubocop', '~> 0.67'

  spec.add_dependency 'rswag', '~>2.0'
end
