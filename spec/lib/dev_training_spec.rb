# frozen_string_literal: true

require 'dev_training'
require 'dev_training/training'

RSpec.describe DevTraining do
  describe '.new' do
    subject(:call) { described_class.new(:fake_token) }

    before do
      allow(DevTraining::Training).to receive(:new) { |arg| arg }
    end

    it 'returns a new `DevTraining::Training`' do
      call
      expect(DevTraining::Training).to have_received(:new)
    end

    it 'passes along the token' do
      expect(call).to be(:fake_token)
    end
  end
end
