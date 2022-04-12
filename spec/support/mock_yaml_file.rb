# frozen_string_literal: true

require 'tempfile'
require 'yaml'

module MockYamlFile
  def mock_yaml(name, content)
    parts = name.split('.')
    base = parts[0..-2].join('.')
    ext = ".#{parts[-1]}"
    Tempfile.new([base, ext]).then do |file|
      file.write(YAML.dump(content))
      file.close
      file.path
    end
  end
end
