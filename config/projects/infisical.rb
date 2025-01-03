name 'infisical-core'
maintainer 'infisical'
homepage 'https://infisical.com'

# Defaults to C:/infisical on Windows
# and /opt/infisical-core on all other platforms
install_dir "#{default_root}/#{name}"
# install_dir File.expand_path(File.join(Omnibus::Config.project_root, 'infisical-tmp'))

require "#{Omnibus::Config.project_root}/lib/infisical/util"
require "#{Omnibus::Config.project_root}/lib/infisical/ohai_helper.rb"
require "#{Omnibus::Config.project_root}/lib/infisical/build/check.rb"

build_version Build.version
build_iteration 1

replace         'infisical'
conflict        'infisical'

license 'MIT'
license_compiled_output true

override :libffi, version: '3.4.2'
override :openssl, version: '3.0.12'

# Creates required build directories
dependency 'preparation'

# infisical dependencies/components

dependency 'omnibus-infisical-gems'
# dependency 'redis'
# dependency 'jemalloc'
# dependency 'logrotate'
dependency 'runit'
# dependency 'consul'

# dependency 'infisical-pg-ctl'
dependency 'infisical-cookbooks'
dependency 'infisical-ctl'

dependency 'infisical-scripts'
# dependency 'postgresql'
# dependency 'pgbouncer'
# dependency 'patroni'

dependency 'infisical'

exclude '**/.git'
exclude '**/bundler/git'

exclude '**/node_modules/@fastify/static/test/**'

# exclude manpages and documentation
exclude 'embedded/man'
exclude 'embedded/share/doc'
exclude 'embedded/share/gtk-doc'
exclude 'embedded/share/info'
exclude 'embedded/share/man'

# exclude rubygems build cache
exclude 'embedded/lib/ruby/gems/*/cache'

# exclude test and some vendor folders
exclude 'embedded/lib/ruby/gems/*/gems/*/spec'
exclude 'embedded/lib/ruby/gems/*/gems/*/test'
exclude 'embedded/lib/ruby/gems/*/gems/*/tests'
# Some vendor folders (e.g. licensee) are needed by GitLab.
# For now, exclude the most space-consuming gems until
# there's a better way to whitelist directories.
exclude 'embedded/lib/ruby/gems/*/gems/rugged*/vendor'
exclude 'embedded/lib/ruby/gems/*/gems/ace-rails*/vendor'
exclude 'embedded/lib/ruby/gems/*/gems/libyajl2*/**/vendor'

# exclude gem build logs
exclude 'embedded/lib/ruby/gems/*/extensions/*/*/*/mkmf.log'
exclude 'embedded/lib/ruby/gems/*/extensions/*/*/*/gem_make.out'

# # exclude C sources
exclude 'embedded/lib/ruby/gems/*/gems/*/ext/*.c'
exclude 'embedded/lib/ruby/gems/*/gems/*/ext/*/*.c'
exclude 'embedded/lib/ruby/gems/*/gems/*/ext/*.o'
exclude 'embedded/lib/ruby/gems/*/gems/*/ext/*/*.o'

# # exclude other gem files
exclude 'embedded/lib/ruby/gems/*/gems/*/*.gemspec'
exclude 'embedded/lib/ruby/gems/*/gems/*/*.md'
exclude 'embedded/lib/ruby/gems/*/gems/*/*.rdoc'
exclude 'embedded/lib/ruby/gems/*/gems/*/*.sh'
exclude 'embedded/lib/ruby/gems/*/gems/*/*.txt'
exclude 'embedded/lib/ruby/gems/*/gems/*/*.ruby'
exclude 'embedded/lib/ruby/gems/*/gems/*/*LICENSE*'
exclude 'embedded/lib/ruby/gems/*/gems/*/CHANGES*'
exclude 'embedded/lib/ruby/gems/*/gems/*/Gemfile'
exclude 'embedded/lib/ruby/gems/*/gems/*/Guardfile'
exclude 'embedded/lib/ruby/gems/*/gems/*/README*'
exclude 'embedded/lib/ruby/gems/*/gems/*/Rakefile'
exclude 'embedded/lib/ruby/gems/*/gems/*/run_tests.rb'

exclude 'embedded/lib/ruby/gems/*/gems/*/Documentation'
exclude 'embedded/lib/ruby/gems/*/gems/*/bench'
exclude 'embedded/lib/ruby/gems/*/gems/*/contrib'
exclude 'embedded/lib/ruby/gems/*/gems/*/doc'
exclude 'embedded/lib/ruby/gems/*/gems/*/doc-api'
exclude 'embedded/lib/ruby/gems/*/gems/*/examples'
exclude 'embedded/lib/ruby/gems/*/gems/*/fixtures'
exclude 'embedded/lib/ruby/gems/*/gems/*/gemfiles'
exclude 'embedded/lib/ruby/gems/*/gems/*/libtest'
exclude 'embedded/lib/ruby/gems/*/gems/*/man'
exclude 'embedded/lib/ruby/gems/*/gems/*/sample_documents'
exclude 'embedded/lib/ruby/gems/*/gems/*/samples'
exclude 'embedded/lib/ruby/gems/*/gems/*/sample'
exclude 'embedded/lib/ruby/gems/*/gems/*/script'
exclude 'embedded/lib/ruby/gems/*/gems/*/t'

# Exclude exe files from Python libraries
exclude 'embedded/lib/python*/**/*.exe'
# Exclude whl files from Python libraries.
exclude 'embedded/lib/python*/**/*.whl'

# Exclude Python cache and distribution info
exclude 'embedded/lib/python*/**/*.dist-info'
exclude 'embedded/lib/python*/**/*.egg-info'
exclude 'embedded/lib/python*/**/__pycache__'

# Enable signing packages
package :rpm do
  vendor 'Infisical, <support@infisical.com>'

  # Enable XZ compression if selected
  compress_xz = Infisical::Util.get_env('COMPRESS_XZ') || 'true'
  if compress_xz == 'true'
    compression_type :xz
    compression_level 6
  end
end

package :deb do
  vendor 'Infisical, <support@infisical.com>'

  # Enable XZ compression if selected
  compress_xz = Infisical::Util.get_env('COMPRESS_XZ') || 'true'
  if compress_xz == 'true'
    compression_type :xz
    compression_level 6
  end
end
