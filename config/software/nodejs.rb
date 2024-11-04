name 'nodejs'

default_version '20.18.0'

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
                      '24a5d58a1d4c2903478f4b7c3cfd2eeb5cea2cae3baee11a4dc6a1fed25fec6c'
                    else
                      '2c5afbc9c18327a8fcab0256bc5b68cca800bd5d8781aae73949e083d39e6a3b'
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
