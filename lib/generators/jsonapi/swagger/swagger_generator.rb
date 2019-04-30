module Jsonapi
  class SwaggerGenerator < Rails::Generators::NamedBase
    desc 'Create a JSONAPI Swagger.'
    source_root File.expand_path('templates', __dir__)

    def create_swagger_file
      swagger_file = File.join(
        'spec/requests',
        class_path,
        spec_file_name
      )
      template 'swagger.rb.erb', swagger_file
    end

    private

    def spec_file_name
      "#{file_name.downcase.pluralize}_spec.rb"
    end

    def model_name
      file_name.downcase.singularize
    end

    def resouces_name
      model_class_name.pluralize
    end

    def route_resouces
      resouces_name.tableize
    end

    def model_class_name
      (class_path + [file_name]).map!(&:camelize).join("::")
    end

    def model_klass
      model_class_name.safe_constantize
    end

    def resource_klass
      "#{model_class_name}Resource".safe_constantize
    end

    def attributes
      resource_klass._attributes.except(:id)
    end

    def relationships
      resource_klass._relationships
    end

    def filters
      resource_klass.filters
    end

    def columns_with_comment
      @columns_with_comment ||= {}.tap do |clos|
        model_klass.columns.each do |col|
          clos[col.name.to_sym] = { type: swagger_type(col), items_type: col.type, is_array: col.array,  nullable: col.null, comment: safe_encode(col.comment) }
        end
      end
    end

    def swagger_type(column)
      return 'array' if column.array

      case column.type
      when :bigint, :integer then 'integer'
      when :boolean          then 'boolean'
      else 'string'
      end
    end

    def t(key, options={})
      options[:scope] = :jsonapi_swagger
      options[:default] = key.to_s.humanize
      content = I18n.t(key, options)
      safe_encode(content)
    end

    def safe_encode(content)
      content&.force_encoding('ASCII-8BIT')
    end
  end
end