# frozen_string_literal: true

require 'application_configuration'
require 'tempfile'

RSpec.describe ApplicationConfiguration do
  include MockYamlFile

  let(:config_file) { mock_yaml('application.yml', { 'test_key' => 'test_value' }) }

  before do
    allow(described_class).to receive(:config_file).and_return(config_file)
  end

  describe '.load!' do
    subject(:call) { described_class.load! }

    before { call }

    it 'populates the Figaro store' do
      expect(Figaro.env.test_key).to eq('test_value')
    end

    it 'populates ENV' do
      expect(ENV['test_key']).to eq('test_value')
    end
  end
end
