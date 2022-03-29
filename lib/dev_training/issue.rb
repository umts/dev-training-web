# frozen_string_literal: true

require 'dev_training/formatting_helpers'

##
# Class representing a GitHub issue, lazily instantiated.
class DevTraining::Issue
  include DevTraining::FormattingHelpers

  # The issue title -- read from, and required to be in the `data`
  attr_accessor :title

  # The issue description -- part of the body, optional, read from the `data`
  attr_accessor :description

  # An array of tasks -- rendered as a task list as part of the body, optional,
  # and read from the `data`
  attr_accessor :subtasks

  ##
  # Arguments:
  #
  #  * `client`:    An `Octokit::Client`
  #  * `repo`:      A DevTraining::Repository
  #  * `milestone`: A DevTraining::Milestone
  #  * `data`:      A `Hash` containing the keys, `title`, `description` (optional),
  #                 and `subtasks` (optional). Likely read in from a YAML file.
  def initialize(client, repo, milestone, data)
    @client = client
    @repo = repo
    @milestone = milestone
    @title = data.fetch('title')
    @description = data['description']
    @subtasks = data['subtasks']
  end

  ##
  # The text of this issue's body (uses DevTraining::FormattingHelpers.format_body)
  def body
    format_body(@description, @subtasks)
  end

  ##
  # The `Sawyer::Resource` representing the GitHub issue. It will be found by `title` and
  # `milestone`, or created in the repository if not found.
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
