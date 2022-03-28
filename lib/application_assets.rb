# frozen_string_literal: true

class ApplicationAssets < Sprockets::Environment
  ASSET_ROOT = '/assets/'

  def initialize
    super(File.join(__dir__, '..'))
    %w[config images javascripts stylesheets].each do |dir|
      append_path "assets/#{dir}"
    end
    append_path 'node_modules'
  end

  def asset_path(file, digest: false)
    method = digest ? :digest_path : :logical_path
    ASSET_ROOT + find_asset(file).send(method)
  end
end
