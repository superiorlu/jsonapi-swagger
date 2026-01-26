# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Jsonapi::Swagger do
  it 'provides defaults' do
    expect(described_class.version).to eq('2.0')
    expect(described_class.info).to eq({ title: 'API V1', version: 'V1' })
    expect(described_class.file_path).to eq('v1/swagger.json')
    expect(described_class.use_rswag).to eq(false)
    expect(described_class.attribute_default).to eq({ type: :string, nullable: true, comment: nil })
  end

  it 'allows configuration via block' do
    described_class.config do |c|
      c.version = '2.1'
      c.info = { title: 'API', version: 'V2' }
      c.file_path = 'v2/swagger.json'
      c.base_path = '/api'
      c.use_rswag = true
    end

    expect(described_class.version).to eq('2.1')
    expect(described_class.info).to eq({ title: 'API', version: 'V2' })
    expect(described_class.file_path).to eq('v2/swagger.json')
    expect(described_class.base_path).to eq('/api')
    expect(described_class.use_rswag).to eq(true)
  end
end
