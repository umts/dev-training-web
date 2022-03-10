class DevTrainingApplication < Sinatra::Base
  set :root, File.join(File.dirname(settings.app_file), '..')
  set :haml, layout: :application

  configure :production do
    set :static, false
  end

  get '/' do
    haml :index
  end
end
