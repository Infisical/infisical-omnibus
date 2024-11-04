
name 'infisical-ctl'

license 'Apache-2.0'
license_file File.expand_path('LICENSE', Omnibus::Config.project_root)
skip_transitive_dependency_licensing true


dependency 'omnibus-ctl'


# source path: File.expand_path('files/infisical-ctl-commands', Omnibus::Config.project_root)

build do
  mkdir "#{install_dir}/bin/"
  block do
    File.open("#{install_dir}/bin/infisical-ctl", 'w') do |file|
      file.print <<-EOH
#!/bin/bash
for ruby_env_var in RUBYOPT \\
                    RUBYLIB \\
                    BUNDLE_BIN_PATH \\
                    BUNDLE_GEMFILE \\
                    GEM_PATH \\
                    GEM_HOME
do
  unset $ruby_env_var
done
# This bumps the default svwait timeout from 7 seconds to 30 seconds
# As documented at http://smarden.org/runit/sv.8.html
export SVWAIT=30

if [ "$1" == "reconfigure" ] && [ "$UID" != "0" ]; then
  echo "This command must be executed as root user"
  exit 1
fi
#{install_dir}/embedded/bin/omnibus-ctl #{File.basename(install_dir)} '#{install_dir}/embedded/service/omnibus-ctl*' "$@"
      EOH
    end
  end
  command "chmod 755 #{install_dir}/bin/infisical-ctl"
  # additional omnibus-ctl commands
  # sync './', "#{install_dir}/embedded/service/omnibus-ctl/"
end
