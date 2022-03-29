# frozen_string_literal: true

require 'application_assets'

RSpec.describe ApplicationAssets do
  subject(:assets) { described_class.new }

  it { is_expected.to be_a(Sprockets::Environment) }

  it 'has paths' do
    expect(assets.paths).not_to be_empty
  end

  describe '#asset_path' do
    # Sprockets needs to be able to find this file in the _real_ proect.
    # Might be cleaner to mock but...
    let(:asset) { 'application.css' }

    context 'when not asked to digest' do
      subject(:call) { assets.asset_path(asset) }

      it 'is a path to the asset' do
        expect(call).to match(%r{/application.css$})
      end
    end

    context 'when asked to digest' do
      subject(:call) { assets.asset_path(asset, digest: true) }

      it 'is a path to the asset' do
        expect(call).to match(%r{/application-[0-9a-f]{64}.css$})
      end
    end
  end
end
