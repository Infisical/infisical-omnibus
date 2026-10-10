require 'tmpdir'

name 'infisical'
default_version "v#{Build.version}"
# default_version "v0.150.0-nightly-20250916.1"

source github: 'Infisical/infisical'

relative_path 'infisical'

dependency 'nodejs'
dependency 'freetds'
dependency 'unixodbc'
dependency 'nodejs'

build do
  env = with_standard_compiler_flags(with_embedded_path)
  env['NODE_OPTIONS'] = '--max-old-space-size=8192'
  # Node 26 builds native addons as C++20: GCC < 14 rejects odbc's bundled node-addon-api,
  # and clang < 15 lacks std::source_location for the V8 headers. Ubuntu 22.04's default clang is 14.
  clang_suffix = File.executable?('/usr/bin/clang-15') ? '-15' : ''
  env['CC'] = "clang#{clang_suffix}"
  env['CXX'] = "clang++#{clang_suffix}"
  # Parallel node-gyp builds otherwise race to download headers into a shared cache, crashing clang with SIGBUS.
  env['npm_config_nodedir'] = "#{install_dir}/embedded"
  # Consumed by the frontend at build time (Vite inlines it) and by the backend
  # at runtime; without it the UI renders no platform version.
  env['INFISICAL_PLATFORM_VERSION'] = "v#{Build.version}"
  env['VITE_INFISICAL_PLATFORM_VERSION'] = "v#{Build.version}"

  block 'Install pinned npm' do
    # Infisical pins npm in build-versions.env, and its devEngines reject the npm
    # bundled with Node. Tags without the pin keep the bundled npm.
    versions_file = "#{project_dir}/build-versions.env"
    npm_version = File.read(versions_file)[/^NPM_VERSION=(.*)$/, 1] if File.exist?(versions_file)

    if npm_version
      unless npm_version.match?(/\A\d+\.\d+\.\d+\z/)
        raise "NPM_VERSION in build-versions.env must be an exact version, got #{npm_version.inspect}"
      end

      # Runs now rather than queued, so npm is swapped before any later step. Pack
      # outside the source tree, where the bundled npm would check the devEngines;
      # npm pack verifies the tarball against the registry's integrity hash.
      npm_dir = "#{install_dir}/embedded/lib/node_modules/npm"
      Dir.mktmpdir('npm-pack') do |dir|
        shellout!("npm pack npm@#{npm_version}", env: env, cwd: dir)
        FileUtils.mkdir("#{dir}/npm")
        shellout!("tar -xzf npm-#{npm_version}.tgz -C npm --strip-components=1", cwd: dir)
        FileUtils.rm_rf(npm_dir)
        FileUtils.mv("#{dir}/npm", npm_dir)
      end

      installed = shellout!('npm --version', env: env).stdout.strip
      raise "Expected npm #{npm_version}, found #{installed}" unless installed == npm_version
    end
  end

  block do
    # Build client application
    Dir.chdir("#{project_dir}/backend") do
      command 'npm ci', env: env, cwd: Dir.pwd
      command 'npm run build', env: env, cwd: Dir.pwd

      mkdir "#{install_dir}/server/"

      # Copy build artifacts
      sync "#{Dir.pwd}/", "#{install_dir}/server", exclude: 'node_modules'
      copy "#{Dir.pwd}/../standalone-entrypoint.sh", "#{install_dir}/server"

      # after build we need only prod node_modules. So we recreate it
      command 'npm ci --omit=dev', env: env, cwd: "#{install_dir}/server"
    end
  end

  block do
    # Build client application
    Dir.chdir("#{project_dir}/frontend") do
      command 'npm ci', env: env, cwd: Dir.pwd
      command 'npm run build', env: env, cwd: Dir.pwd

      frontend_folder_name = 'frontend-build'

      mkdir "#{install_dir}/server/#{frontend_folder_name}"

      # Copy build artifacts
      copy "#{Dir.pwd}/dist/*", "#{install_dir}/server/#{frontend_folder_name}"
    end
  end

  # whitelist_file(/-musl.node/)
end
