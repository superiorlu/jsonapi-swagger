require 'forwardable'
module Jsonapi
  module Swagger
    class SerializableResource
      extend Forwardable

      def_delegators :@sr, :type_val, :attribute_blocks, :relationship_blocks, :link_blocks

      def initialize(sr)
        @sr = sr
      end

      alias attributes attribute_blocks

      def relationships
        {}.tap do |relations|
          relationship_blocks.each do |rel, block|
            relations[rel] = OpenStruct.new(class_name: rel.to_s)
          end
        end
      end

      # TODO: from jsonapi serializable resource
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