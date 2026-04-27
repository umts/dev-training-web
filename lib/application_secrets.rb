# frozen_string_literal: true

require 'securerandom'

##
# helper module for loading secret values from environment/credentials.
module ApplicationSecrets
  class << self
    def session_secret
      production? ? CREDENTIALS['session_secret'] : ENV.fetch('SESSION_SECRET') { SecureRandom.hex(64) }
    end

    def github_key = production? ? CREDENTIALS['github_key'] : ENV.fetch('GITHUB_KEY', nil)

    def github_secret = production? ? CREDENTIALS['github_secret'] : ENV.fetch('GITHUB_SECRET', nil)

    private

    def production? = ENV['RACK_ENV'] == 'production'
  end
end
