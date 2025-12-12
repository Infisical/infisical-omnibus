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
      tag = Infisical::Util.shellout_stdout('git tag --sort=-v:refname | head -n 1') || 'v0.0.1'
      if match = tag.match(/^v(.+)$/)
        return match[1]
      end

      tag
    end
  end
end
