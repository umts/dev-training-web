# frozen_string_literal: true

require 'yaml'

RSpec.describe 'config/collaborators.yml' do
  let :file do
    Pathname.new(__dir__).join('../../config/collaborators.yml').expand_path
  end

  let :yaml do
    file.open { |f| YAML.safe_load f }
  end

  it 'exists' do
    expect(file).to exist
  end

  it 'is a list' do
    expect(yaml).to be_a(Array)
  end
end
