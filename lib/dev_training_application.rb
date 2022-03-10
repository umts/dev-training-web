class DevTrainingApplication < Sinatra::Base
  configure do
    set :root, File.join(File.dirname(settings.app_file), '..')
    set :haml, layout: :application
  end

  get '/' do
    haml :index
  end
end
