# frozen_string_literal: true

require 'dev_training/formatting_helpers'

class DevTraining::Issue
  include DevTraining::FormattingHelpers

  attr_accessor :title, :description, :subtasks

  def initialize(client, repo, milestone, data)
    @client = client
    @repo = repo
    @milestone = milestone
    @title = data.fetch('title')
    @description = data['description']
    @subtasks = data['subtasks']
  end

  def body
    format_body(@description, @subtasks)
  end

  def resource
    @resource ||= find || create
  end

  private

  def create
    @client.create_issue @repo.resource.full_name, @title, body,
                         milestone: @milestone.resource.number
  end

  def find
    @client.issues(@repo.resource.full_name, milestone: @milestone.resource.number).find do |issue|
      issue.title == @title
    end
  end
end
