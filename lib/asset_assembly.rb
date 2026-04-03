# frozen_string_literal: true

##
# Preconfigured instance of Propshaft::Assembly.
class AssetAssembly < Propshaft::Assembly
  def initialize
    super(config)
  end

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def config
    ActiveSupport::OrderedOptions.new.tap do |c|
      root_path = Pathname(__dir__).join('../')
      c.paths = [root_path.join('assets/builds').expand_path]
      c.output_path = root_path.join('public/assets').expand_path
      c.manifest_path = root_path.join('public/assets/.manifest.json').expand_path
      c.prefix = '/assets'
      c.version = '1'
      c.compilers = [
        ['text/css', Propshaft::Compiler::CssAssetUrls],
        ['text/css', Propshaft::Compiler::SourceMappingUrls],
      ]
      c.file_watcher = ENV['RACK_ENV'] == 'development' ? ActiveSupport::EventedFileUpdateChecker : nil
      c.sweep_cache = ENV['RACK_ENV'] == 'development'
      c.integrity_hash_algorithm = 'sha256'
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
end
