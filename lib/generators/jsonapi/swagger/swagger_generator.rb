# frozen_string_literal: true

module Jsonapi
  class SwaggerGenerator < ::Rails::Generators::NamedBase
    source_root File.expand_path('templates', __dir__)

    def copy_serializable_file
      template 'swagger.rb.erb',
               File.join('spec/requests', class_path,
                         "#{spec_file_name}.rb")
    end

    private

    def spec_file_name
      "#{file_name}_spec.rb"
    end

    def serializable_class_name
      (class_path + [serializable_file_name]).map!(&:camelize).join('::')
    end

    def model_klass
      # TODO(beauby): Ensure the model class exists.
      class_name.safe_constantize
    end

    def type
      model_klass.model_name.plural
    end

    def attr_names
      attrs = model_klass.new.attribute_names - ['id']
      fk_attrs = model_klass.reflect_on_all_associations(:belongs_to)
                            .map(&:foreign_key)
      attrs - fk_attrs
    end

    def has_one_rel_names
      model_klass.reflect_on_all_associations(:has_one).map(&:name) +
        model_klass.reflect_on_all_associations(:belongs_to).map(&:name)
    end

    def has_many_rel_names
      model_klass.reflect_on_all_associations(:has_many).map(&:name)
    end
  end
end
