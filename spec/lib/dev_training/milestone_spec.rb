# frozen_string_literal: true

require_relative 'with_mock_client'
require 'dev_training/milestone'

RSpec.describe DevTraining::Milestone do
  subject(:milestone) { described_class.new(client, repo) }

  include_context 'with mock client'
  let(:milestone_name) { described_class::NAME }

  describe '#resource' do
    subject(:call) { milestone.resource }

    context 'when a milestone with the right title exists' do
      let(:existing_milestone) { Struct.new(:title).new(milestone_name) }

      before do
        allow(client).to receive(:list_milestones)
          .with('repo/name').and_return([existing_milestone])
        allow(client).to receive(:create_milestone)
      end

      it 'returns that milestone' do
        expect(call).to eq(existing_milestone)
      end

      it "doesn't create a new milestone" do
        call
        expect(client).not_to have_received(:create_milestone)
      end
    end

    context 'when a milestone with the right title does not exist' do
      before do
        allow(client).to receive(:list_milestones).with('repo/name').and_return([])
        allow(client).to receive(:create_milestone).and_return(:a_new_milestone)
      end

      it 'creates a milestone' do
        call
        expect(client).to have_received(:create_milestone).with('repo/name', milestone_name)
      end

      it 'returns the created issue' do
        expect(call).to eq(:a_new_milestone)
      end
    end
  end
end
