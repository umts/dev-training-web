# frozen_string_literal: true

require 'dev_training/repository'
require 'dev_training/training'
require 'dev_training_application'
require 'faker'
require 'omniauth'
require 'rack/test'
require 'rspec-html-matchers'
require_relative '../support/mock_yaml_file'

RSpec.describe DevTrainingApplication do
  include MockYamlFile
  include Rack::Test::Methods
  include RSpecHtmlMatchers

  let(:app) { described_class }
  let(:auth) { Faker::Omniauth.github }
  let(:session_secret) { 'SECRETSECRET' }

  before do
    app.set :sessions, secret: session_secret
    OmniAuth.config.test_mode = true
  end

  describe 'GET /auth/github/callback' do
    before do
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(auth)
      get '/auth/github/callback'
    end

    it 'stores auth info in the session' do
      expect(last_request.session[:auth][:info]).to be_a(Hash)
    end

    it 'stores auth credentials in the session' do
      expect(last_request.session[:auth][:credentials]).to be_a(Hash)
    end

    it 'redirects' do
      expect(last_response.status).to eq(302)
    end

    it 'redirects to /' do
      follow_redirect!
      expect(last_request.path).to eq('/')
    end
  end

  describe 'POST /create' do
    subject(:call) { post '/create', params, env_credentials }

    let(:training) { instance_double(DevTraining::Training) }
    let(:env_credentials) do
      { 'rack.session' => { auth: { credentials: { token: :fake_token } } } }
    end
    let(:params) { { authenticity_token: last_request.session[:csrf] } }
    let :repo do
      Struct.new(:html_url, :full_name).new('http://repos.com/example/repo', 'example/repo')
    end

    before do
      allow(DevTraining).to receive(:new).with(:fake_token).and_return(training)
      allow(training).to receive(:repo).and_return(Struct.new(:resource).new(repo))
      %i[create_issues! add_collaborators! create_readme!].each do |method|
        allow(training).to receive(method)
      end
      get '/'
    end

    it 'initializes a new DevTraining::Training' do
      call
      expect(DevTraining).to have_received(:new).with(:fake_token)
    end

    context 'with configuration' do
      let(:collaborators) { %w[able baker charlie] }
      let(:collaborators_file) { mock_yaml('collaborators.yml', collaborators) }
      let(:qualification) { { 'title' => 'Be awesome!' } }
      let(:qualifications_file) { mock_yaml('qualifications.yml', qualification) }

      before do
        app.set :collaborators, collaborators_file
        app.set :qualifications, qualifications_file
      end

      it 'creates issues from the qualifications file' do
        call
        expect(training).to have_received(:create_issues!).with([qualification])
      end

      it 'adds collaborators frim the collaborators file' do
        call
        expect(training).to have_received(:add_collaborators!).with(collaborators)
      end
    end

    it 'creates a readme using the configured template file' do
      app.set :readme, :the_template
      call
      expect(training).to have_received(:create_readme!).with(:the_template)
    end

    it 'is an HTTP success' do
      call
      expect(last_response.status).to eq(200)
    end

    it 'renders the success view' do
      call
      expect(last_response.body).to have_tag(:h1, text: 'Success!')
    end

    it 'links to the created repo' do
      call
      expect(last_response.body).to have_tag(:a, with: { href: repo.html_url })
    end
  end

  describe 'GET /' do
    subject(:call) { get '/' }

    context 'without auth in the session' do
      it 'is an HTTP success' do
        call
        expect(last_response.status).to eq(200)
      end

      it 'renders the welcome view' do
        call
        expect(last_response.body).to have_tag(:h1, text: 'Welcome!')
      end

      it 'has a button to authorize' do
        call
        expect(last_response.body).to have_tag(:form, with: { action: '/auth/github' }) do
          with_tag :input, with: { type: 'submit', value: 'Authorize' }
        end
      end
    end

    context 'with auth in the session' do
      before do
        OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(auth)
        get '/auth/github/callback'
      end

      it 'is an HTTP success' do
        call
        expect(last_response.status).to eq(200)
      end

      it 'renders the ready view' do
        call
        expect(last_response.body).to have_tag(:h1, text: /Welcome Back/)
      end

      it 'says what the repo will be' do
        call
        repo_name = "#{auth[:info][:nickname]}/#{DevTraining::Repository::NAME}"
        expect(last_response.body).to have_tag(:tt, text: repo_name)
      end

      it 'has a button to create the training repo' do
        call
        expect(last_response.body).to have_tag(:form, with: { action: '/create' }) do
          with_tag :input, with: { type: 'submit', value: 'Create' }
        end
      end
    end
  end
end
