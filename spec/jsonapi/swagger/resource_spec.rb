# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Jsonapi::Swagger::Resource do
  before do
    stub_const('JSONAPI', Module.new)
    stub_const('JSONAPI::Resource', Class.new)
    stub_const('JSONAPI::Serializable', Module.new)
    stub_const('JSONAPI::Serializable::Resource', Class.new)
    stub_const('FastJsonapi', Module.new)
    stub_const('FastJsonapi::ObjectSerializer', Class.new)
  end

  it 'wraps JSONAPI::Resource subclasses' do
    klass = Class.new(JSONAPI::Resource) do
      def self._attributes = { id: {}, name: {} }
      def self._relationships = {}
      def self.sortable_fields = []
      def self.creatable_fields = []
      def self.updatable_fields = []
      def self.filters = {}
      def self.mutable? = false
    end
    stub_const('UserResource', klass)

    wrapper = described_class.with('User')
    expect(wrapper).to be_a(Jsonapi::Swagger::JsonapiResource)
    expect(wrapper.attributes).to eq({ id: {}, name: {} })
  end

  it 'wraps JSONAPI::Serializable::Resource subclasses' do
    klass = Class.new(JSONAPI::Serializable::Resource) do
      def self.type_val = :users
      def self.attribute_blocks = { id: nil, name: nil }
      def self.relationship_blocks = { company: nil }
      def self.link_blocks = {}
    end
    stub_const('SerializableUser', klass)

    wrapper = described_class.with('User')
    expect(wrapper).to be_a(Jsonapi::Swagger::SerializableResource)
    expect(wrapper.attributes).to eq({ id: nil, name: nil })
    expect(wrapper.relationships.keys).to eq([:company])
  end

  it 'wraps FastJsonapi::ObjectSerializer subclasses' do
    klass = Class.new(FastJsonapi::ObjectSerializer) do
      def self.attributes_to_serialize = { id: {}, name: {} }
      def self.relationships_to_serialize = {}
    end
    stub_const('UserSerializer', klass)

    wrapper = described_class.with('User')
    expect(wrapper).to be_a(Jsonapi::Swagger::FastJsonapiResource)
    expect(wrapper.attributes).to eq({ id: {}, name: {} })
  end

  it 'raises when no supported resource is found' do
    expect { described_class.with('User') }.to raise_error(Jsonapi::Swagger::Error, /not support/i)
  end
end
