name 'nodejs'

default_version '26.12.1'

license 'MIT'
license_file 'LICENSE'
skip_transitive_dependency_licensing true

build do
  env = with_standard_compiler_flags(with_embedded_path)

  # Detect platform architecture
  arch = if windows?
           'x64'
         else
           `uname -m`.chomp == 'x86_64' ? 'x64' : 'arm64'
         end

  # Download binary distribution
  binary_url = "https://nodejs.org/dist/v#{version}/node-v#{version}-linux-#{arch}.tar.gz"
  binary_checksum = if arch == 'x64'
                      '0fd1eb7770598f52a21995edf6ed35fc690400fa437c2386af329519e9143132'
                    else
                      'a6c01af459dd8972ab3fb08ee5da81244d26ba8c4944a62d5bbba8c597ae154f'
                    end

  command "curl -SLO #{binary_url}"
  command "echo '#{binary_checksum}  node-v#{version}-linux-#{arch}.tar.gz' | sha256sum -c -"
  command "tar -xzf node-v#{version}-linux-#{arch}.tar.gz --strip-components=1"

  # Install to the destination
  command "mkdir -p #{install_dir}/embedded/bin"
  command "mkdir -p #{install_dir}/embedded/lib"

  # Copy binaries and lib files
  copy 'bin/node', "#{install_dir}/embedded/bin/"
  copy 'bin/npm', "#{install_dir}/embedded/bin/"
  copy 'bin/npx', "#{install_dir}/embedded/bin/"
  command "cp -r lib/node_modules #{install_dir}/embedded/lib/"
  command "mkdir -p #{install_dir}/embedded/include"
  command "cp -r include/node #{install_dir}/embedded/include/"

  # Set up npm and npx wrappers
  block do
    File.open("#{install_dir}/embedded/bin/npm", 'w') do |file|
      file.print <<~EOH
        #!/bin/sh
        export NODE_PATH="#{install_dir}/embedded/lib/node_modules"
        exec "#{install_dir}/embedded/bin/node" "#{install_dir}/embedded/lib/node_modules/npm/bin/npm-cli.js" "$@"
      EOH
    end

    File.open("#{install_dir}/embedded/bin/npx", 'w') do |file|
      file.print <<~EOH
        #!/bin/sh
        export NODE_PATH="#{install_dir}/embedded/lib/node_modules"
        exec "#{install_dir}/embedded/bin/node" "#{install_dir}/embedded/lib/node_modules/npm/bin/npx-cli.js" "$@"
      EOH
    end
  end

  # Make binaries executable
  command "chmod +x #{install_dir}/embedded/bin/*"

  # Create version manifest
  block do
    File.open("#{install_dir}/version-manifest.txt", 'w') do |f|
      f.puts "nodejs #{version}"
    end
  end
end
