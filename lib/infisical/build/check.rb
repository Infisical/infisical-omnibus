require_relative "../util"

module Build
  class Check
    class << self
      def use_system_ssl?
         Infisical::Util.get_env('USE_SYSTEM_SSL') == 'true'
      end
    end
  end
end