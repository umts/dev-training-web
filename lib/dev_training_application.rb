class DevTrainingApplication < Sinatra::Base
  set :root, File.join(File.dirname(settings.app_file), '..')
  set :sprockets, Sprockets::Environment.new(root)
  set :haml, layout: :application

  configure :production do
    set :static, false
  end

  configure do
    sprockets.append_path File.join(root, 'assets', 'stylesheets')
    sprockets.append_path File.join(root, 'assets', 'javascripts')
    sprockets.append_path File.join(root, 'assets', 'images')
  end

  get '/' do
    haml :index
  end
end
