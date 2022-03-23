# frozen_string_literal: true

require 'dev_training'
require 'sinatra'
require 'rack/protection'

class DevTrainingApplication < Sinatra::Base
  set :root, File.join(File.dirname(settings.app_file), '..')
  set :collaborators, Proc.new { File.join(root, 'config', 'collaborators.yml') }
  set :qualifications, Proc.new { File.join(root, 'config', 'qualifications.yml') }
  set :readme, Proc.new { File.join(root, 'config', 'template_readme.md') }

  set :sessions, secret: ENV['session_secret']
  set :haml, layout: :application

  configure :production do
    set :static, false
  end

  use OmniAuth::Builder do
    options = { scope: 'user:email, repo, read:org' }
    options[:provider_ignores_state] = true if development?
    provider :github, ENV['github_key'], ENV['github_secret'], options
  end

  use Rack::Protection, use: %i[authenticity_token cookie_tossing form_token remote_referrer]

  get '/auth/github/callback' do
    auth = request.env['omniauth.auth']
    session[:auth] = { info: auth['info'], credentials: auth['credentials'] }

    redirect to '/'
  end

  post '/create' do
    token  = session[:auth][:credentials][:token]
    training = DevTraining.new(token)

    collaborators = YAML.load(File.open(settings.collaborators, &:read))
    qualifications = YAML.load_stream(File.open(settings.qualifications, &:read))

    training.create_issues! qualifications
    training.add_collaborators! collaborators
    training.repo.create_readme File.open(settings.readme)
  end

  get '/' do
    if session[:auth].nil? || session[:auth].empty?
      haml :welcome
    else
      @name = session[:auth][:info][:name]
      haml :ready
    end
  end
end
