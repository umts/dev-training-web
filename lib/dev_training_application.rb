class DevTrainingApplication < Sinatra::Base
  configure do
    set :root, File.join(File.dirname(settings.app_file), '..')
    set :static, settings.production? ? false : true
    set :haml, layout: :application
  end

  get '/' do
    haml :index
  end
end
