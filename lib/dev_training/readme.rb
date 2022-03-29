# frozen_string_literal: true

require 'uri'

##
# Class representing the "\README" file in the training repository. It is
# responsible for rendering a template file through Tilt and creating the
# file in the Training repository.
class DevTraining::Readme
  # Name of the file in the repository
  FILENAME = 'README.md'

  ##
  # Arguments:
  #
  # * `filename`: The path to a template file or a type that Tilt knows how
  #               to render
  # * `client`:   An `Octokit::Client`
  # * `repo`:     A DevTraining::Repository that will hold the \README
  def initialize(filename, client, repo)
    @template = Tilt.new(filename, trim: '-')
    @client = client
    @repo = repo
  end

  ##
  # The rendered content of the \README template. Note that the template is
  # passed `self` with it's call to render, which means that you have access to
  # instance variables and (even `private`) methods of this instance within the
  # template.
  def content
    @template.render(self)
  end

  ##
  # The `Sawyer::Resource` representing the contents of the readme if found, or
  # the contents and commit information if not found and created with `content`
  #
  # Note that _updating_ a file in a repository is a much more involved
  # process; we don't attempt it. If any \README (in any format) exists in the
  # repository, we let it be.
  def resource
    @resource ||= readme || create_readme
  end

  ## Some of these private methods act as helper methods in the template
  private

  def message
    "Add README.md -- Training created #{Time.now.iso8601}"
  end

  def create_readme
    @client.create_contents repo_name, FILENAME, message, content
  end

  def readme
    @client.readme repo_name
  rescue Octokit::NotFound
    nil
  end

  def repo_name
    @repo.resource.full_name
  end

  def repo_relative(path)
    base = URI.parse(@repo.resource.html_url)
    URI.join(base, "#{base.path}/#{path}")
  end

  def user_name
    @client.user.name || @client.user.login
  end
end
