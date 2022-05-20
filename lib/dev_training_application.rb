# frozen_string_literal: true

require 'app_client'
require 'application_assets'
require 'dev_training'
require 'rack/protection'
require 'yaml'

##
# Sinatra application resposible for the web-app-ish components of training creation
class DevTrainingApplication < Sinatra::Base
  set :root, File.join(File.dirname(settings.app_file), '..')
  set :collaborators, (proc { File.join root, 'config', 'collaborators.yml' })
  set :qualifications, (proc { File.join root, 'config', 'qualifications.yml' })
  set :readme, (proc { File.join root, 'config', 'README.md.erb' })
  set :app_client, (proc { AppClient.new ENV['github_key'], ENV['github_secret'] })

  set :sprockets, ApplicationAssets.new
  set :sessions, (ENV['session_secret'] ? { secret: ENV['session_secret'] } : {})
  set :haml, layout: :application

  # :nocov:
  configure :production do
    set :static, false
  end
  # :nocov:

  before { @csrf_token = request.env['rack.session']['csrf'] }

  helpers do
    def asset_path(file)  # :nodoc:
      settings.sprockets.asset_path(file, digest: settings.environment == :production)
    end
  end

  use OmniAuth::Builder do
    options = { scope: 'user:email, repo' }
    options[:provider_ignores_state] = true if development?
    provider :github, ENV['github_key'], ENV['github_secret'], options
  end

  use Rack::Protection, use: %i[authenticity_token cookie_tossing form_token remote_referrer]

  get '/auth/github/callback' do
    auth = request.env['omniauth.auth']
    session[:auth] = { info: auth['info'], credentials: auth['credentials'] }

    redirect to '/'
  end

  get('/auth/failure') { redirect to '/' }

  post '/create' do
    token = session[:auth][:credentials][:token]
    training = DevTraining.new(token)

    collaborators = YAML.safe_load(File.read(settings.collaborators))
    qualifications = YAML.load_stream(File.read(settings.qualifications))

    training.create_issues! qualifications
    training.add_collaborators! collaborators
    training.create_readme! settings.readme

    settings.app_client.revoke_token token
    @repo_resource = training.repo.resource
    haml :success
  end

  get '/' do
    if session[:auth].nil? || session[:auth].empty? ||
       !settings.app_client.token_valid?(session[:auth][:credentials][:token])
      haml :welcome
    else
      info = session[:auth][:info]
      @name = info[:name]
      @repo_name = "#{info[:nickname]}/#{DevTraining::Repository::NAME}"
      haml :ready
    end
  end
end
