namespace :git do
  desc 'Allow use of shared git repository'
  task :allow_shared do
    on release_roles(:all), in: :groups, limit: fetch(:git_max_concurrent_connections), wait: fetch(:git_wait_interval) do
      with fetch(:git_environmental_variables) do
        execute :git, :config, '--global', '--replace-all', 'safe.directory', repo_path, repo_path
      end
    end
  end
end
