# frozen_string_literal: true

require 'dev_training/issue'
require 'dev_training/milestone'
require 'dev_training/readme'
require 'dev_training/repository'

module DevTraining
  ##
  # Main Developer training object, used to coordinate resource creation and
  # updates
  class Training
    # An `Octokit::Client`
    attr_reader :client

    # The DevTraining::Repository for this training
    attr_reader :repo

    ##
    # Initialized with a GitHub token. In the console, you can use a Personal
    # Access Token, but the Sinatra app uses an OAuth token. Note that many of
    # the objects in a training instance create GitHub resources lazily. So,
    # nothing will be created on GitHub at initialization.
    def initialize(token)
      @client = Octokit::Client.new access_token: token
      @repo = DevTraining::Repository.new(@client)
      @milestone = DevTraining::Milestone.new(@client, @repo)
    end

    ##
    # Takes an array of login names and adds them in turn as outside
    # collaborators to the repository.
    def add_collaborators!(collaborators)
      collaborators.each { |user| @repo.add_collaborator user }
    end

    ##
    # Takes a filename that will be passed to a new DevTraining::Readme, and
    # then returns the resource as created on or returned from GitHub.
    def create_readme!(filename)
      DevTraining::Readme.new(filename, @client, @repo).resource
    end

    ##
    # Takes an `Array` of `Hash`es, each in the format a DevTraining::Issue
    # expects, and returns an `Array` of resources as created on or returned from
    # GitHub.
    def create_issues!(stream)
      stream.map do |data|
        DevTraining::Issue.new(@client, @repo, @milestone, data).resource
      end
    end
  end
end
