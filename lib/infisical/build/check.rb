require_relative '../util'

module Build
  class Check
    class << self
      def use_system_ssl?
        Infisical::Util.get_env('USE_SYSTEM_SSL') == 'true'
      end
    end
  end

  class << self
    def version
      tag = Infisical::Util.shellout_stdout('git describe --tags --abbrev=0') || 'v0.0.1'
      if match = tag.match(/v(\d+\.\d+\.\d+)/)
        return match[1]
      end

      tag
    end
  end
end
