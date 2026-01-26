# frozen_string_literal: true

require 'spec_helper'
require 'tempfile'

RSpec.describe Jsonapi::Swagger::Json do
  describe '#parse_doc' do
    it 'returns an empty hash if file does not exist' do
      json = described_class.new('nope/swagger.json')
      expect(json.parse_doc).to eq({})
    end

    it 'returns an empty hash if content is not JSON' do
      file = Tempfile.new(['swagger', '.json'])
      file.write('not-json')
      file.flush

      json = described_class.new(file.path)
      expect(json.parse_doc).to eq({})
    ensure
      file.close!
    end

    it 'parses valid JSON' do
      file = Tempfile.new(['swagger', '.json'])
      file.write('{"paths":{}}')
      file.flush

      json = described_class.new(file.path)
      expect(json.parse_doc).to eq({ 'paths' => {} })
    ensure
      file.close!
    end
  end
end
