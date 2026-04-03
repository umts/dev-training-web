# frozen_string_literal: true

##
# helper module for loading secret values from environment/credentials.
module ApplicationSecrets
  class << self
    def sessions = production? ? { secret: CREDENTIALS['session_secret'] } : {}

    def github_key = production? ? CREDENTIALS['github_key'] : ENV.fetch('GITHUB_KEY', nil)

    def github_secret = production? ? CREDENTIALS['github_secret'] : ENV.fetch('GITHUB_SECRET', nil)

    private

    def production? = ENV['RACK_ENV'] == 'production'
  end
end
