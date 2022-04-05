# frozen_string_literal: true

require_relative 'with_mock_client'
require 'dev_training/issue'
require 'dev_training/milestone'
require 'dev_training/repository'
require 'dev_training/training'

RSpec.describe DevTraining::Training do
  subject(:training) { described_class.new(:fake_token) }

  include_context 'with mock client'
  let(:milestone) { DevTraining::Milestone.new(client, repo) }

  before do
    allow(Octokit::Client).to receive(:new).with(access_token: :fake_token).and_return(client)
    allow(DevTraining::Repository).to receive(:new).and_return(repo)
    allow(DevTraining::Milestone).to receive(:new).and_return(milestone)
  end

  describe '#add_collaborators!' do
    subject(:call) { training.add_collaborators!(%w[alpha bravo charlie]) }

    before do
      allow(repo).to receive(:add_collaborator)
      call
    end

    it 'adds the correct number of collaborators to the training repo' do
      expect(repo).to have_received(:add_collaborator).exactly(3).times
    end

    it 'uses the elements of the array as arguments' do
      expect(repo).to have_received(:add_collaborator).with('bravo')
    end
  end

  describe '#create_readme!' do
    subject(:call) { training.create_readme!('fake-file') }

    let(:readme) { instance_double(DevTraining::Readme) }

    before do
      allow(DevTraining::Readme).to receive(:new).and_return(readme)
      allow(readme).to receive(:resource).and_return(:the_resource)
    end

    it 'initializes a new readme' do
      call
      expect(DevTraining::Readme).to have_received(:new).with('fake-file', client, repo)
    end

    it 'returns the readme resource' do
      expect(call).to eq(:the_resource)
    end
  end

  describe '#create_issues!' do
    subject(:call) { training.create_issues!(%w[delta echo foxtrot]) }

    let(:issue) { instance_double(DevTraining::Issue) }

    before do
      allow(DevTraining::Issue).to receive(:new).and_return(issue)
      allow(issue).to receive(:resource).and_return(:an_issue)
    end

    it 'initializes the correct number of issues' do
      call
      expect(DevTraining::Issue).to have_received(:new)
        .with(client, repo, milestone, anything).exactly(3).times
    end

    it 'returns a collection of the issue resources' do
      expect(call).to eq(%i[an_issue an_issue an_issue])
    end
  end
end
