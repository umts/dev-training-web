# frozen_string_literal: true

class DevTraining
  require 'dev_training/issue'
  require 'dev_training/milestone'
  require 'dev_training/repository'

  attr_reader :client, :repo

  def initialize(token)
    @client = Octokit::Client.new access_token: token
    @repo = DevTraining::Repository.new(@client)
    @milestone = DevTraining::Milestone.new(@client, @repo)
  end

  def add_collaborators!(colaborators)
    colaborators.users.each { |user| @repo.add_colaborator user }
    colaborators.teams.each { |team| @repo.add_team team }
  end

  def create_issues!(stream)
    stream.map do |data|
      DevTraining::Issue.new(@client, @repo, @milestone, data).resource
    end
  end
end
