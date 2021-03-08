module Jsonapi
  class SwaggerGenerator < Rails::Generators::NamedBase
    desc 'Create a JSONAPI Swagger.'
    source_root File.expand_path('templates', __dir__)

    def create_swagger_file
      if Jsonapi::Swagger.use_rswag
        template 'swagger.rb.erb', spec_file
      else
        template 'swagger.json.erb', json_file
      end
    end

    private

    def doc
      @doc ||= swagger_json.parse_doc
    end

    def spec_file
      @spec_file ||= File.join(
        'spec/requests',
        class_path,
        spec_file_name
      )
    end

    def json_file
      @json_file ||= File.join(
        'swagger',
        class_path,
        swagger_file_path
      )
    end

    def swagger_version
      Jsonapi::Swagger.version
    end

    def swagger_info
      JSON.pretty_generate(Jsonapi::Swagger.info)
    end

    def swagger_base_path
      Jsonapi::Swagger.base_path
    end

    def swagger_host
      Jsonapi::Swagger.host
    end

    def swagger_file_path
      Jsonapi::Swagger.file_path
    end

    def swagger_json
      @swagger_json ||= Jsonapi::Swagger::Json.new(json_file)
    end

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

    def sortable_fields_desc
      t(:sortable_fields) + ': (-)' + sortable_fields.join(',')
    end

    def ori_sortable_fields_desc
      tt(:sortable_fields) + ': (-)' + sortable_fields.join(',')
    end

    def model_klass
      file_name.camelize.safe_constantize
    end

    def resource_klass
      @resource_klass ||= Jsonapi::Swagger::Resource.with(model_class_name)
    end

    def attributes
      resource_klass.attributes.except(:id)
    end

    def relationships
      resource_klass.relationships
    end

    def sortable_fields
      resource_klass.sortable_fields
    end

    def creatable_fields
      resource_klass.creatable_fields - relationships.keys
    end

    def updatable_fields
      resource_klass.updatable_fields - relationships.keys
    end

    def filters
      resource_klass.filters
    end

    def mutable?
      resource_klass.mutable?
    end

    def attribute_default
      Jsonapi::Swagger.attribute_default
    end

    def transform_method
      @transform_method ||= resource_klass.transform_method if resource_klass.respond_to?(:transform_method)
    end

    def columns_with_comment(need_encoding: true)
      @columns_with_comment ||= {}.tap do |clos|
        clos.default_proc = proc do |h, k|
          h[k] = attribute_default
        end
        model_klass.columns.each do |col|
          col_name = transform_method ? col.name.send(transform_method) : col.name
          is_array = col.respond_to?(:array) ? col.array : false
          clos[col_name.to_sym] = { type: swagger_type(col), items_type: col.type, is_array: is_array,  nullable: col.null, comment: col.comment }
          clos[col_name.to_sym][:comment] = safe_encode(col.comment) if need_encoding
        end
      end
    end

    def swagger_type(column)
      return 'array' if column.respond_to?(:array) && column.array

      case column.type
      when :bigint, :integer then 'integer'
      when :boolean          then 'boolean'
      else 'string'
      end
    end

    def relation_table_name(relation)
      return relation.class_name.tableize if relation.respond_to?(:class_name)
      return relation.name if relation.respond_to?(:name)
    end

    def t(key, options={})
      content = tt(key, options)
      safe_encode(content)
    end

    def tt(key, options={})
      options[:scope] = :jsonapi_swagger
      options[:default] = key.to_s.humanize
      I18n.t(key, options)
    end

    def safe_encode(content)
      content&.force_encoding('ASCII-8BIT')
    end
  end
end
