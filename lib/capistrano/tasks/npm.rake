# frozen_string_literal: true

namespace :npm do
  desc 'Install the project dependencies via npm.'
  task :install do
    on roles :web do
      within release_path do
        execute :npm, 'install', %w[--production --silent --no-spin]
      end
    end
  end

  desc 'Remove extraneous packages via npm.'
  task :prune do
    on roles :web do
      within release_path do
        execute :npm, 'prune', %w[--production]
      end
    end
  end

  desc 'Rebuild via npm'
  task :rebuild do
    on roles :web do
      within release_path do
        execute :npm, 'rebuild'
      end
    end
  end
end
