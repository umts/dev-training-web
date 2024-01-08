# frozen_string_literal: true

require_relative 'with_mock_client'
require 'dev_training/repository'

RSpec.describe DevTraining::Repository do
  subject(:repository) { described_class.new(client) }

  include_context 'with mock client'
  let(:repo_name) { described_class::NAME }

  describe '#add_collaborator' do
    subject(:call) { repository.add_collaborator 'someone' }

    let(:resource) { Struct.new(:full_name).new("user/#{repo_name}") }

    before do
      allow(client).to receive_messages(repository?: true, repository: resource)
      allow(client).to receive(:add_collaborator)
    end

    it 'adds the collaborator to this repository' do
      call
      expect(client).to have_received(:add_collaborator)
        .with("user/#{repo_name}", 'someone')
    end
  end

  describe '#resource' do
    subject(:call) { repository.resource }

    context 'when the repository exists on GitHub' do
      before do
        allow(client).to receive_messages(repository?: true, repository: :that_resource)
      end

      it 'returns the existing resource' do
        expect(call).to eq(:that_resource)
      end
    end

    context 'when the repository does not exist on GitHub' do
      before do
        allow(client).to receive_messages(repository?: false, create_repository: :a_new_resource)
      end

      it 'returns the new resource' do
        expect(call).to eq(:a_new_resource)
      end

      it 'creates the repo' do
        call
        expect(client).to have_received(:create_repository).with(repo_name, instance_of(Hash))
      end

      it 'creates a private repo' do
        call
        expect(client).to have_received(:create_repository)
          .with(anything, hash_including(private: true))
      end
    end
  end
end
