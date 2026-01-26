# frozen_string_literal: true

require 'json'

require 'logger'
require 'active_support'
require 'active_support/core_ext/hash/except'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/object/try'
require 'active_support/core_ext/string/inflections'

require 'i18n'
I18n.enforce_available_locales = false if I18n.respond_to?(:enforce_available_locales=)

require 'jsonapi/swagger'

RSpec.configure do |config|
  config.around do |example|
    swagger = Jsonapi::Swagger
    ivars = %i[
      @version
      @info
      @file_path
      @base_path
      @use_rswag
      @attribute_default
    ]

    saved = ivars.to_h { |ivar| [ivar, swagger.instance_variable_get(ivar)] }

    example.run
  ensure
    saved.each { |ivar, value| swagger.instance_variable_set(ivar, value) }
  end

  config.disable_monkey_patching!
  config.order = :random
  Kernel.srand config.seed
end
