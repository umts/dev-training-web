# frozen_string_literal: true

require 'application_configuration'
require 'tempfile'

RSpec.describe ApplicationConfiguration do
  let(:config_file) do
    Tempfile.new(%w[application .yml]).then do |file|
      file.write('test_key: test_value')
      file.close
      file.path
    end
  end

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
