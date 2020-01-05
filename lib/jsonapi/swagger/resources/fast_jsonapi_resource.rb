require 'forwardable'
module Jsonapi
  module Swagger
    class FastJsonapiResource
      extend Forwardable

      def_delegators :@fr, :attributes_to_serialize, :relationships_to_serialize, :sortable_fields,
                           :creatable_fields, :updatable_fields, :filters, :mutable?, :transform_method

      def initialize(fr)
        @fr = fr
      end

      alias attributes attributes_to_serialize
      alias relationships relationships_to_serialize

      # TODO: fast_jsonapi resource
      def sortable_fields
        []
      end

      def creatable_fields
        []
      end

      def updatable_fields
        []
      end

      def filters
        []
      end

      def mutable?
        false
      end
    end
  end
end