name 'infisical'
default_version "infisical/v#{Build.version}"
# default_version "infisical/v0.129.1-postgres"

source github: 'Infisical/infisical'

relative_path 'infisical'

dependency 'nodejs'
dependency 'freetds'
dependency 'unixodbc'
dependency 'nodejs'

build do
  env = with_standard_compiler_flags(with_embedded_path)
  env['NODE_OPTIONS'] = "--max-old-space-size=8192"

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
      command 'npm ci --only-production', env: env, cwd: "#{install_dir}/server"
    end
  end

  block do
    # Build client application
    Dir.chdir("#{project_dir}/frontend") do
      command 'npm ci', env: env, cwd: Dir.pwd
      command 'npm run build', env: env, cwd: Dir.pwd

      frontend_folder_name = 'frontend-build'

      mkdir  "#{install_dir}/server/#{frontend_folder_name}"

      # Copy build artifacts
      copy "#{Dir.pwd}/dist/*", "#{install_dir}/server/#{frontend_folder_name}"
    end
  end

  # whitelist_file(/-musl.node/)
end
