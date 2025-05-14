require 'json'

def get_build_version
  return unless File.exist?('/opt/infisical-core/version-manifest.json')

  version_manifest = JSON.parse(File.read('/opt/infisical-core/version-manifest.json'))
  version_manifest['build_version']
end

add_command("version", "Version of the infisical installed version", 2) do |*args|
  build_version = get_build_version
  if build_version
    puts "Infisical version is: #{build_version}"
  else
    puts "Version information not available"
    exit 1
  end
end
