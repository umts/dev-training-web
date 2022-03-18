# frozen_string_literal: true

class DevTraining::Repository
  NAME = 'umts-dev-training'

  def initialize(client, readme: nil)
    @client = client
    @repo = Octokit::Repository.new owner: @client.user.login, name: NAME
    @readme = readme
  end

  def resource
    @resource ||= (repo? ? repo : create_repo)
  end

  private

  def create_repo
    created = @client.create_repository @repo.name,
                                        private: true, has_issues: true, has_projects: false,
                                        has_wiki: false, has_downloads: false, auto_init: false
    @client.create_contents(@repo, 'README.md', 'Add README', @readme) if @readme
    created
  end

  def repo
    @client.repository @repo
  end

  def repo?
    @client.repository? @repo
  end
end
