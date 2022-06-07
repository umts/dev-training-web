# frozen_string_literal: true

require 'tempfile'
require 'yaml'

module MockYamlFile
  def mock_yaml(name, content)
    Tempfile.open(name.split(/(?=\.[^.]+\z)/)) do |file|
      file.write(YAML.dump(content))
      file.path
    end
  end
end
