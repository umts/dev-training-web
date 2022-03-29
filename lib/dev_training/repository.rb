# frozen_string_literal: true

##
# Class representing the training progress repository, lazily instantiated. It
# is the context that a number of the other objects in this app act within, and
# as such, a number of them take an instance of this class as an initialization
# parameter:
#
#  * DevTraining::Issue
#  * DevTraining::Milestone
#  * DevTraining::Readme
class DevTraining::Repository
  NAME = 'umts-dev-training'

  ##
  # Takes an `Octokit::Client`
  def initialize(client)
    @client = client
    @repo = Octokit::Repository.new owner: @client.user.login, name: NAME
  end

  ##
  # Add the GitHub user, `login` as an outside collaborator on the repository.
  def add_collaborator(login)
    @client.add_collaborator(resource.full_name, login)
  end

  ##
  # The `Sawyer::Resource` representing the repository. It will be found by
  # name, or created if not found for the authenticated user.
  def resource
    @resource ||= (repo? ? repo : create_repo)
  end

  private

  def create_repo
    @client.create_repository @repo.name,
                              private: true, has_issues: true, has_projects: false,
                              has_wiki: false, has_downloads: false, auto_init: false
  end

  def repo
    @client.repository @repo
  end

  def repo?
    @client.repository? @repo
  end
end
