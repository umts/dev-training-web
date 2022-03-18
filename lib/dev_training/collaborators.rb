# frozen_string_literal: true

class DevTraining::Collaborators

  attr_reader :users, :teams

  def initialize(collaborators = [])
    case colaborators
    when Array
      @users = collaborators
      @teams = []
    when Hash
      @users = Array(collaborators[:users] || collaborators['users'])
      @teams = Array(collaborators[:teams] || collaborators['teams'])
    else
      raise ArgumentError, 'must be and Array or Hash'
    end
  end
end
