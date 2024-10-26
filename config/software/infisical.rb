name "infisical"
default_version "1.0.0"

dependency "nodejs"

source path: "#{Omnibus::Config.project_root}/server"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  # Install dependencies
  command "npm ci", env: env

  # Create required directories
  mkdir "#{install_dir}/src"
  # mkdir "#{install_dir}/logs"

  # Copy application files
  copy "src/*", "#{install_dir}/src/"
  copy "node_modules", "#{install_dir}/"
  copy "package.json", "#{install_dir}/"
  copy "package-lock.json", "#{install_dir}/"
  # copy ".env.example", "#{install_dir}/config/.env.example"

  # Create symlinks for logs
  # link "#{install_dir}/logs", "/var/log/fastify-server"
end
