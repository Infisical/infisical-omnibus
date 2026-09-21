name 'nodejs'

default_version '22.23.2'

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
                      'b294a556e639d64338823920e5866c21c02741742d2e1529ee1a225c1ec9252a'
                    else
                      '013b59cfd2819703a6f4a14ab891fc46fc2a4e3f5bcd92de3fb4929b43e35b30'
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
