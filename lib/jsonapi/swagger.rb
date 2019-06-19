# frozen_string_literal: true

require 'jsonapi/swagger/version'
require 'jsonapi/swagger/railtie' if defined?(Rails)
require 'jsonapi/swagger/json'

module Jsonapi
  module Swagger
    class Error < StandardError; end

    class << self
      attr_accessor :version, :info, :file_path, :base_path, :use_rswag

      def config
        yield self
      end

      def version
        @version ||= '2.0'
      end

      def info
        @info ||= { title: 'API V1', version: 'V1' }
      end

      def file_path
        @file_path ||= 'v1/swagger.json'
      end

      def base_path
        @base_path
      end

      def use_rswag
        @use_rswag ||= false
      end
    end
  end
end
