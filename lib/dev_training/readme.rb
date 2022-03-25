# frozen_string_literal: true
require 'uri'

class DevTraining::Readme
  FILENAME = 'README.md'

  def initialize(filename, client, repo)
    @template = Tilt.new(filename, trim: '-')
    @client = client
    @repo = repo
  end

  def content
    @template.render(self)
  end

  def resource
    @resource ||= readme || create_readme
  end

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
    return nil
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
