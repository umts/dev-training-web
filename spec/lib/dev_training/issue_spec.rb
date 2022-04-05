# frozen_string_literal: true

require 'dev_training/issue'
require 'dev_training/repository'
require 'dev_training/milestone'

RSpec.describe DevTraining::Issue do
  subject(:issue) { ->(data) { described_class.new(client, repo, milestone, data) } }

  let(:client) { instance_double(Octokit::Client) }
  let(:repo) { DevTraining::Repository.new(client) }
  let(:milestone) { DevTraining::Milestone.new(client, repo) }
  let(:user) { Struct.new(:login).new('fake-user') }

  before do
    allow(client).to receive(:user).and_return(user)
  end

  describe '#title' do
    it 'is required' do
      expect { issue['no_title' => 'nope'] }.to raise_error(KeyError)
    end

    it 'comes from the data' do
      expect(issue['title' => 'golf'].title).to eq('golf')
    end
  end

  describe '#description' do
    it 'comes from the data' do
      expect(issue['title' => 'india', 'description' => 'juliet'].description).to eq('juliet')
    end
  end

  describe '#subtasks' do
    it 'comes from the data' do
      expect(issue['title' => 'lima', 'subtasks' => %w[mike november]].subtasks)
        .to eq(%w[mike november])
    end
  end

  describe '#body' do
    subject(:call) { this_issue.body }

    let :this_issue do
      issue['title' => 'oscar', 'description' => 'papa', 'subtasks' => %w[quebec romeo]]
    end

    before { allow(this_issue).to receive(:format_body).and_return('THE BODY') }

    it 'uses format_body with its own attributes' do
      call
      expect(this_issue).to have_received(:format_body).with('papa', %w[quebec romeo])
    end

    it 'returns the result' do
      expect(call).to eq('THE BODY')
    end
  end

  describe '#resource' do
    subject(:call) { issue['title' => 'sierra'].resource }

    before do
      allow(repo).to receive(:resource).and_return(Struct.new(:full_name).new('repo/name'))
      allow(milestone).to receive(:resource).and_return(Struct.new(:number).new(1))
    end

    context 'when an issue with the right title exists' do
      let(:existing_issue) { Struct.new(:title).new('sierra') }

      before do
        allow(client).to receive(:issues)
          .with('repo/name', milestone: 1).and_return([existing_issue])
        allow(client).to receive(:create_issue)
      end

      it 'returns that issue' do
        expect(call).to eq(existing_issue)
      end

      it "doesn't create a new issue" do
        call
        expect(client).not_to have_received(:create_issue)
      end
    end

    context 'when an issue with the right title does not exist' do
      before do
        allow(client).to receive(:issues).with('repo/name', milestone: 1).and_return([])
        allow(client).to receive(:create_issue).and_return(:a_new_issue)
      end

      it 'creates an issue' do
        call
        expect(client).to have_received(:create_issue)
          .with('repo/name', 'sierra', nil, milestone: 1)
      end

      it 'returns the created issue' do
        expect(call).to eq(:a_new_issue)
      end
    end
  end
end
