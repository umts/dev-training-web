# frozen_string_literal: true

require 'capistrano/setup'
require 'capistrano/deploy'

require 'capistrano/scm/git'
install_plugin Capistrano::SCM::Git

require 'capistrano/bundler'
require 'capistrano/passenger'

Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
