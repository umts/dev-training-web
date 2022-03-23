# frozen_string_literal: true

class DevTraining::Repository
  NAME = 'umts-dev-training'

  def initialize(client)
    @client = client
    @repo = Octokit::Repository.new owner: @client.user.login, name: NAME
  end

  def add_collaborator(login)
    @client.add_collaborator(resource.full_name, login)
  end

  def create_readme(content)
    return if readme?

    if content.is_a?(File) || content.is_a?(Tempfile)
      @client.create_contents(resource.full_name, 'README.md', 'Add README', file: content)
    else
      @client.create_contents(resource.full_name, 'README.md', 'Add README', content)
    end
  end

  def resource
    @resource ||= (repo? ? repo : create_repo)
  end

  private

  def create_repo
    @client.create_repository @repo.name,
                              private: true, has_issues: true, has_projects: false,
                              has_wiki: false, has_downloads: false, auto_init: false
  end

  def readme?
    @client.readme(@repo)
    return true
  rescue Octokit::NotFound
    return false
  end

  def repo
    @client.repository @repo
  end

  def repo?
    @client.repository? @repo
  end
end
