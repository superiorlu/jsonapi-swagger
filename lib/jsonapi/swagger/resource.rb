require 'forwardable'
module Jsonapi
  module Swagger
    class Resource
      def self.with(model_class_name)
        if (resource_class = "#{model_class_name}Resource".safe_constantize)
          unless resource_class < JSONAPI::Resource
            raise Jsonapi::Swagger::Error, "#{resource_class} is not Subclass of JSONAPI::Resource!"
          end
          require 'jsonapi/swagger/resources/jsonapi_resource'
          return Jsonapi::Swagger::JsonapiResource.new(resource_class)
        elsif (resource_class = serializable_class_name(model_class_name).safe_constantize)
          unless resource_class < JSONAPI::Serializable::Resource
            raise Jsonapi::Swagger::Error, "#{resource_class} is not Subclass of JSONAPI::Serializable::Resource!"
          end
          require 'jsonapi/swagger/resources/serializable_resource'
          return Jsonapi::Swagger::SerializableResource.new(resource_class)
        elsif (resource_class = "#{model_class_name}Serializer".safe_constantize)
          unless resource_class < FastJsonapi::ObjectSerializer
            raise Jsonapi::Swagger::Error, "#{resource_class} is not Subclass of FastJsonapi::ObjectSerializer!"
          end
          require 'jsonapi/swagger/resources/fast_jsonapi_resource'
          return Jsonapi::Swagger::FastJsonapiResource.new(resource_class)
        else
          raise Jsonapi::Swagger::Error, "#{model_class_name} not support!"
        end
      end

      def self.serializable_class_name(model_class_name)
        parts = model_class_name.split('::')
        parts[-1] = "Serializable#{parts[-1]}"
        parts.join('::')
      end
    end
  end
end
