name "infisical"
default_version "main"


source github: "Infisical/infisical"

relative_path "infisical"

dependency "nodejs"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  block do
    # Build client application
    Dir.chdir("#{project_dir}/backend") do
      command "npm ci", env: env, cwd: Dir.pwd
      command "npm run build", env: env, cwd: Dir.pwd

      mkdir  "#{install_dir}/server"
      
      # Copy build artifacts
      copy "#{Dir.pwd}/package.json", "#{install_dir}/server/"
      copy "#{Dir.pwd}/package-lock.json", "#{install_dir}/server/"
      copy "#{Dir.pwd}/dist/*", "#{install_dir}/server"

      # after build we need only prod node_modules. So we recreate it
      delete "#{Dir.pwd}/node-modules"
      command "npm ci --only-production", env: env, cwd: Dir.pwd
      copy "#{Dir.pwd}/node-modules", "#{install_dir}/server/"
    end
  end

  block do
    # Build client application
    Dir.chdir("#{project_dir}/frontend") do
      command "npm ci", env: env, cwd: Dir.pwd
      command "npm run build", env: env, cwd: Dir.pwd

      frontend_folder_name = "frontend-build"

      mkdir  "#{install_dir}/server/#{frontend_folder_name}/.next"
      mkdir  "#{install_dir}/server/#{frontend_folder_name}/scripts"
      mkdir  "#{install_dir}/server/#{frontend_folder_name}/.next/cache/images"
      mkdir  "#{install_dir}/server/#{frontend_folder_name}/.next/static"
      
      # Copy build artifacts
      copy "#{Dir.pwd}/package.json", "#{install_dir}/server/#{frontend_folder_name}"
      copy "#{Dir.pwd}/package-lock.json", "#{install_dir}/server/#{frontend_folder_name}"
      copy "#{Dir.pwd}/.next/standalone", "#{install_dir}/server/#{frontend_folder_name}"
      copy "#{Dir.pwd}/.next/static", "#{install_dir}/server/#{frontend_folder_name}/.next/static"
      copy "#{Dir.pwd}/.next/cache/images", "#{install_dir}/server/#{frontend_folder_name}/.next/cache/images"
      copy "#{Dir.pwd}/scripts", "#{install_dir}/server/#{frontend_folder_name}/scripts"
      copy "#{Dir.pwd}/public", "#{install_dir}/server/#{frontend_folder_name}"
    end
  end
  

  # Install dependencies
  # command "npm ci", env: env

  # Create required directories
  # mkdir "#{install_dir}/src"
  # mkdir "#{install_dir}/logs"

  # Copy application files
  # copy "src/*", "#{install_dir}/src/"
  # copy "node_modules", "#{install_dir}/"
  # copy "package.json", "#{install_dir}/"
  # copy "package-lock.json", "#{install_dir}/"
  # copy ".env.example", "#{install_dir}/config/.env.example"

  # Create symlinks for logs
  # link "#{install_dir}/logs", "/var/log/fastify-server"
end
