# frozen_string_literal: true

class DevTraining::Milestone
  NAME = 'Programmer Qualification'

  def initialize(client, repo)
    @client = client
    @repo = repo
  end

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
