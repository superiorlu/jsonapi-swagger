# frozen_string_literal: true

require 'jsonapi/swagger/version'
require 'jsonapi/swagger/railtie' if defined?(Rails)

module Jsonapi
  module Swagger
    class Error < StandardError; end
  end
end
