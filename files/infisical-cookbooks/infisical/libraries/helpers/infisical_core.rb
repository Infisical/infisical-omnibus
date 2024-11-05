require_relative 'base_helper'

class GitlabRailsHelper < BaseHelper
  attr_accessor :node

  def public_attributes
    {
      'infisical' => {}
    }
  end
end
