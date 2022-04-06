# frozen_string_literal: true

namespace :yarn do
  desc 'Install the project dependencies via yarn.'
  task :install do
    on roles :web do
      within release_path do
        execute :yarn, 'install', %w[--production]
      end
    end
  end

  desc 'Remove extraneous packages via yarn.'
  task :prune do
    on roles :web do
      within release_path do
        execute :yarn, 'prune'
      end
    end
  end

  desc 'Rebuild via yarn'
  task :rebuild do
    on roles :web do
      within release_path do
        execute :yarn, 'rebuild'
      end
    end
  end
end
