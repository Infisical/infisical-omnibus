require_relative 'base_helper'

class GitlabRailsHelper < BaseHelper
  attr_accessor :node

  def public_attributes
    {
      'infisical' => {
        'infisical_core' => node['infisical']['infisical_core'].select do |key, _value|
          %w[db_database].include?(key)
        end.merge(
          'databases' => node['infisical']['infisical_core']['databases'].transform_values do |value|
            value['db_database']
          end
        )
      }
    }
  end
end
