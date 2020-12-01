# frozen_string_literal: true

require 'jsonapi/swagger/version'
require 'jsonapi/swagger/railtie' if defined?(Rails)
require 'jsonapi/swagger/json'
require 'jsonapi/swagger/resource'

module Jsonapi
  module Swagger
    class Error < StandardError; end

    class << self
      attr_accessor :allow_methods_for_attributes, :version, :info, :file_path, :base_path, :use_rswag

      def allow_methods_for_attributes
        @allow_methods_for_attributes ||= true
      end

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

      def attribute_default
        @attribute_default ||= { type: :string, nullable: true, comment: nil }
      end
    end
  end
end
