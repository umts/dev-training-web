# frozen_string_literal: true

%w[setup deploy scm/git bundler passenger pending rails/assets].each do |lib|
  require "capistrano/#{lib}"
end
install_plugin Capistrano::SCM::Git

Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
