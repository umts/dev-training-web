# frozen_string_literal: true

##
# Wrapper class for our applications's Sprockets environment.
class ApplicationAssets < Sprockets::Environment
  # request path prepended to each asset -- this is where the Rack app is
  # _mounted_ OR a directory within /public containing compiled assets
  ASSET_ROOT = '/assets/'

  ##
  # Configure Sprockets' search paths here
  def initialize
    super(File.join(__dir__, '..'))
    %w[config images javascripts stylesheets].each do |dir|
      append_path "assets/#{dir}"
    end
    append_path 'node_modules'
  end

  ##
  # Returns an HTTP path that will resolve to the requested asset. The optional
  # digest: parameter will cause the return result to include the hexidigest of
  # the asset so that it will resolve to a compiled, digested asset in
  # production.
  def asset_path(file, digest: false)
    method = digest ? :digest_path : :logical_path
    ASSET_ROOT + find_asset(file).send(method)
  end
end
