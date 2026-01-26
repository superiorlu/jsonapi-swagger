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
  config.disable_monkey_patching!
  config.order = :random
  Kernel.srand config.seed
end
