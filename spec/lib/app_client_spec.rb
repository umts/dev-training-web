# frozen_string_literal: true

require 'app_client'

RSpec.describe AppClient do
  subject(:app_client) { described_class.new(client_id, client_secret) }

  let(:client) { instance_double(Octokit::Client) }
  let(:client_id) { 'FAKECLIENTID' }
  let(:client_secret) { 'FAKECLIENTSECRET' }

  before do
    allow(Octokit::Client).to receive(:new)
    app_client.instance_variable_set(:@client, client)
  end

  it 'delegates to the Octokit client' do
    expect(app_client.send('__getobj__')).to eq(client)
  end

  describe '.initialize' do
    it 'sets the client id' do
      expect(Octokit::Client).to have_received(:new)
        .with(hash_including(client_id: client_id))
    end

    it 'sets the client secret' do
      expect(Octokit::Client).to have_received(:new)
        .with(hash_including(client_secret: client_secret))
    end
  end

  describe '#revoke_token' do
    subject(:call) { app_client.revoke_token('a-token') }

    before do
      allow(client).to receive(:delete)
      allow(client).to receive(:client_id).and_return(client_id)
      allow(client).to receive(:check_application_authorization)
    end

    context 'with a valid token' do
      it 'deletes the token' do
        call
        expect(client).to have_received(:delete)
          .with("applications/#{client_id}/grant", access_token: 'a-token')
      end
    end

    context 'without a valid token' do
      before do
        allow(client).to receive(:check_application_authorization)
          .and_raise(Octokit::NotFound)
      end

      it { is_expected.to be_nil }

      it "doesn't attempt to delete the token" do
        call
        expect(client).not_to have_received(:delete)
      end
    end
  end

  describe '#token_valid?' do
    subject(:call) { app_client.token_valid?('a-token') }

    before do
      allow(client).to receive(:check_application_authorization)
    end

    it 'Checks for authorization' do
      call
      expect(client).to have_received(:check_application_authorization)
        .with('a-token', any_args)
    end

    context 'when checking authorization succeeds' do
      it { is_expected.to be(true) }
    end

    context 'when checking authorization fails' do
      before do
        allow(client).to receive(:check_application_authorization)
          .and_raise(Octokit::NotFound)
      end

      it { is_expected.to be(false) }
    end
  end
end
