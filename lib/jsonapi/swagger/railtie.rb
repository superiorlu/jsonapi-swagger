# frozen_string_literal: true

module Jsonapi
  module Swagger
    class Railtie < ::Rails::Railtie
      initializer 'jsonapi-swagger-i18n' do |app|
        locates = app.config.i18n.available_locales
        locates_dir = File.expand_path('../../i18n', __dir__)
        Array(locates).each do |loc|
          locate_file = File.join(locates_dir, "#{loc}.yml")
          I18n.load_path.push(locate_file) if File.exist?(locate_file) && !I18n.load_path.include?(locate_file)
        end
      end
    end
  end
end
