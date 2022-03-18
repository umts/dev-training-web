# frozen_string_literal: true

class DevTraining
  require 'dev_training/repository'

  attr_reader :client

  def initialize(token)
    @client = Octokit::Client.new access_token: token
    @repo = DevTraining::Repository.new(@client)
  end
end
