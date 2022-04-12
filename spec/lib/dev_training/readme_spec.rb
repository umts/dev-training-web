# frozen_string_literal: true

require_relative 'with_mock_client'
require 'dev_training/readme'

RSpec.describe DevTraining::Readme do
  subject(:readme) { described_class.new(filename, client, repo) }

  include_context 'with mock client'
  let(:filename) { File.join(__dir__, '../../fixtures/README.md.erb') }
  let(:template) { Tilt.new(filename, trim: '-') }

  before do
    allow(Tilt).to receive(:new).with(filename, trim: '-').and_return(template)
  end

  describe '#content' do
    subject(:call) { readme.content }

    before { allow(template).to receive(:render).and_call_original }

    it 'renders the template' do
      call
      expect(template).to have_received(:render)
    end

    it 'has the DevTraining::Readme as a context' do
      call
      expect(template).to have_received(:render).with(readme)
    end

    it 'renders ERB' do
      expect(call).to include('1 + 1 = 2')
    end

    it 'has access to helper methods' do # Namely, `#user_name`
      expect(call).to include(user.name)
    end
  end

  describe '#resource' do
    subject(:call) { readme.resource }

    context 'when a readme exists in the repo' do
      before do
        allow(client).to receive(:readme).and_return(:the_readme)
        allow(client).to receive(:create_contents)
      end

      it 'returns that readme' do
        expect(call).to eq(:the_readme)
      end

      it "doesn't create a new readme" do
        call
        expect(client).not_to have_received(:create_contents)
      end
    end

    context 'when a readme does not exist in the repo' do
      before do
        allow(client).to receive(:readme).and_raise(Octokit::NotFound)
        allow(client).to receive(:create_contents).and_return(:a_new_readme)
      end

      it 'creates a new readme' do
        call
        expect(client).to have_received(:create_contents)
          .with('repo/name', DevTraining::Readme::FILENAME, anything, anything)
      end

      it 'returns the created readme' do
        expect(call).to eq(:a_new_readme)
      end
    end
  end
end
