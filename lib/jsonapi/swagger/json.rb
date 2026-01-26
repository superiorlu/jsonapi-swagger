module Jsonapi
  module Swagger
    class Json

      attr_accessor :path

      def initialize(path = 'swagger/v1/swagger.json')
        @path = path
      end

      def parse_doc
        @doc ||= begin
          parsed = JSON.parse(load)

          Hash.new { |h, k| h[k] = {} }.tap do |doc|
            doc.merge!(parsed.is_a?(Hash) ? parsed : {})
            doc['paths'] = {} unless doc['paths'].is_a?(Hash)
          end
        rescue StandardError
          Hash.new { |h, k| h[k] = {} }.tap do |doc|
            doc['paths'] = {}
          end
        end
      end

      def base_path
        Jsonapi::Swagger.base_path
      end

      def load
        @data ||= if File.exist?(path)
                  IO.read(path)
                else
                  puts "create swagger.json in #{path}"
                  '{}'
                end
      end


    end
  end
end
