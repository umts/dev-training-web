# frozen_string_literal: true

##
# Class representing a GitHub milestone, lazily instantiated
class DevTraining::Milestone
  # Constant name of the 'graduation' milestone
  NAME = 'Programmer Qualification'

  ##
  # Takes an `Octokit::Client` and a DevTraining::Repository
  def initialize(client, repo)
    @client = client
    @repo = repo
  end

  ##
  # The `Sawyer::Resource` representing the GitHub milestone. It will be found
  # by `title` or created in the repository if not found.
  def resource
    @resource ||= find || create
  end

  private

  def create
    @client.create_milestone(@repo.resource.full_name, NAME)
  end

  def find
    @client.list_milestones(@repo.resource.full_name).find do |milestone|
      milestone.title == NAME
    end
  end
end
