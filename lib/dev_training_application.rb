# frozen_string_literal: true

require 'app_client'
require 'application_secrets'
require 'asset_assembly'
require 'dev_training'
require 'logger'
require 'rack/common_logger'
require 'rack/protection'
require 'yaml'

##
# Sinatra application resposible for the web-app-ish components of training creation
class DevTrainingApplication < Sinatra::Base
  set :root, File.join(File.dirname(settings.app_file), '..')
  set :access_log, (proc do
    logfile = File.join root, 'log', "#{settings.environment}_access.log"
    Logger.new logfile
  end)
  set :error_log, (proc do
    logfile = File.join root, 'log', "#{settings.environment}_error.log"
    File.open logfile, 'a+'
  end)
  configure do
    enable :logging
    use Rack::CommonLogger, settings.access_log
  end

  set :collaborators, proc { File.join root, 'config', 'collaborators.yml' }
  set :qualifications, proc { File.join root, 'config', 'qualifications.yml' }
  set :readme, proc { File.join root, 'config', 'README.md.erb' }
  set :app_client, (proc do
    AppClient.new ApplicationSecrets.github_key, ApplicationSecrets.github_secret
  end)

  enable :sessions
  set :session_secret, ApplicationSecrets.session_secret
  set :haml, layout: :application

  use Rack::Sendfile
  set :static_cache_control, [:public, immutable: true, max_age: 31_536_000]
  set :asset_assembly, AssetAssembly.new
  configure :development, :test do
    use Propshaft::Server, settings.asset_assembly
  end

  before do
    @csrf_token = request.env['rack.session']['csrf']
    request.env['rack.errors'] = settings.error_log
  end

  helpers do
    def asset_path(file) # :nodoc:
      settings.asset_assembly.resolver.resolve(file) || raise(Propshaft::MissingAssetError, file)
    end
  end

  use OmniAuth::Builder do
    options = { scope: 'user:email, repo' }
    options[:provider_ignores_state] = true if ENV['RACK_ENV'] == 'development'
    provider :github, ApplicationSecrets.github_key, ApplicationSecrets.github_secret, options
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

    collaborators = YAML.safe_load_file(settings.collaborators)
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
