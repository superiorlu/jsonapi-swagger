# frozen_string_literal: true

require 'spec_helper'

require 'erb'
require 'fileutils'
require 'ostruct'
require 'tmpdir'

module Rails
  module Generators
    class NamedBase
      class << self
        attr_accessor :_source_root, :_destination_root

        def desc(*)
          nil
        end

        def source_root(path = nil)
          self._source_root = path if path
          _source_root
        end

        def destination_root(path = nil)
          self._destination_root = path if path
          _destination_root
        end
      end

      def initialize(name)
        @name = name
      end

      def file_name
        @name.to_s.underscore
      end

      def class_path
        []
      end

      def template(src, dest)
        src_path = File.join(self.class.source_root, src)
        out_path = File.join(self.class.destination_root, dest)
        FileUtils.mkdir_p(File.dirname(out_path))
        File.write(out_path, ERB.new(File.read(src_path), trim_mode: '-').result(binding))
      end
    end
  end
end

require 'jsonapi/swagger/json'
require 'jsonapi/swagger/resource'
require 'jsonapi/swagger/resources/jsonapi_resource'
require 'generators/jsonapi/swagger/swagger_generator'

RSpec.describe Jsonapi::SwaggerGenerator do
  around do |example|
    Dir.mktmpdir('jsonapi-swagger-spec') do |dir|
      described_class.destination_root(dir)
      example.run
    end
  end

  before do
    stub_const('JSONAPI', Module.new)
    stub_const('JSONAPI::Resource', Class.new)

    stub_const('User', Class.new)
    User.define_singleton_method(:columns) do
      [
        OpenStruct.new(name: 'id', type: :integer, null: false, comment: 'ID'),
        OpenStruct.new(name: 'name', type: :string, null: true, comment: 'Name')
      ]
    end

    relation = OpenStruct.new(class_name: 'Company', table_name: 'companies')
    relation.define_singleton_method(:belongs_to?) { true }

    resource = Class.new(JSONAPI::Resource) do
      def self._attributes
        { id: nil, name: nil }
      end

      def self._relationships
        { company: OpenStruct.new(class_name: 'Company', table_name: 'companies') }
      end

      def self.sortable_fields
        [:name]
      end

      def self.creatable_fields
        [:name]
      end

      def self.updatable_fields
        [:name]
      end

      def self.filters
        { name: {} }
      end

      def self.mutable?
        true
      end
    end

    # Ensure relationship object has belongs_to? and table_name.
    resource._relationships[:company].define_singleton_method(:belongs_to?) { true }

    stub_const('UserResource', resource)

    Jsonapi::Swagger.config do |c|
      c.use_rswag = false
      c.base_path = '/api'
      c.file_path = 'v1/swagger.json'
    end
  end

  it 'generates swagger JSON via template' do
    gen = described_class.new('User')
    gen.create_swagger_file

    out = File.join(described_class.destination_root, 'swagger', 'v1', 'swagger.json')
    expect(File.exist?(out)).to eq(true)

    json = JSON.parse(File.read(out))
    expect(json['swagger']).to eq('2.0')
    expect(json['basePath']).to eq('/api')
    expect(json['paths']).to include('/users')
    expect(json['paths']).to include('/users/{id}')
    expect(json['paths']['/users']).to include('post')
  end
end
