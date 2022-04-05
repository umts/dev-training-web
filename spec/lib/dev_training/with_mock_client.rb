# frozen_string_literal: true

require 'dev_training/repository'
require 'octokit'

RSpec.shared_context 'with mock client' do
  let(:client) { instance_double(Octokit::Client) }
  let(:repo) { DevTraining::Repository.new(client) }
  let(:repo_resource) { Struct.new(:full_name).new('repo/name') }
  let(:user) { Struct.new(:login, :name).new('fake-user', 'Fake Name') }

  before do
    allow(client).to receive(:user).and_return(user)
    allow(repo).to receive(:resource).and_return(repo_resource)
  end
end
