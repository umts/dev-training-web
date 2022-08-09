# frozen_string_literal: true

require 'octokit'

##
# A wrapper around an `Octokit::Client` that authenticates as an OAuth
# application. Contains a few methods for manipulating OAuth tokens
# as well.
class AppClient < Delegator
  attr_accessor :client # :nodoc:
  private :client, :client=
  alias __setobj__ client=
  alias __getobj__ client

  ##
  # Takes two arguments, an OAuth client ID and an OAuth client secret. These
  # are used to initialize an `Octokit::Client` acting as the OAuth
  # application. This class delegates missing instance methods to that client.
  def initialize(client_id, client_secret)
    super Octokit::Client.new(client_id: client_id, client_secret: client_secret)
  end

  ##
  # Revoke the given access token for the OAuth application.
  def revoke_token(token)
    return unless token_valid? token

    delete "applications/#{client_id}/grant", access_token: token
  end

  ##
  # Check to see whether the given token is valid for the OAuth application.
  def token_valid?(token)
    check_application_authorization token, accept: 'application/vnd.github.v3+json'
    true
  rescue Octokit::NotFound
    false
  end
end
