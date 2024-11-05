require 'openssl'

class SecretsHelper
  SECRETS_FILE = '/etc/infisical/infisical-secrets.json'.freeze
  SECRETS_FILE_CHEF_ATTR = '_infisical_secrets_file_path'.freeze
  SKIP_GENERATE_SECRETS_CHEF_ATTR = '_skip_generate_secrets'.freeze

  def self.generate_hex(chars)
    SecureRandom.hex(chars)
  end

  def self.generate_base64(bytes)
    SecureRandom.base64(bytes)
  end

  def self.generate_urlsafe_base64(bytes = 32)
    SecureRandom.urlsafe_base64(bytes)
  end

  def self.generate_rsa(bits)
    OpenSSL::PKey::RSA.new(bits)
  end

  def self.generate_x509(subject:, validity:, key:)
    cert = OpenSSL::X509::Certificate.new
    cert.subject = cert.issuer = OpenSSL::X509::Name.parse(subject)
    cert.not_before = Time.now
    cert.not_after = (DateTime.now + validity).to_time
    cert.public_key = key.public_key
    cert.serial = 0x0
    cert.version = 2
    cert.sign(key, OpenSSL::Digest.new('SHA256'))

    cert
  end

  def self.generate_keypair(bits:, subject:, validity:)
    key = generate_rsa(bits)
    cert = generate_x509(subject: subject, validity: validity, key: key)

    [key, cert]
  end

  # Load the secrets from disk
  #
  # @return [Hash]  empty if no secrets
  def self.load_infisical_secrets(path = SecretsHelper::SECRETS_FILE)
    existing_secrets = {}

    existing_secrets = Chef::JSONCompat.from_json(File.read(path)) if File.exist?(path)

    existing_secrets
  end

  # Reads the secrets into the Infisical config singleton
  def self.read_infisical_secrets(path = SecretsHelper::SECRETS_FILE)
    existing_secrets = load_infisical_secrets(path)

    existing_secrets.each do |k, v|
      if Infisical[k]
        v.each do |pk, p|
          # NOTE: Specifying a secret in infisical.rb will take precedence over "infisical-secrets.json"
          Infisical[k][pk] ||= p
        end
      else
        warn("Ignoring section #{k} in #{path}, does not exist in infisical.rb")
      end
    end
  end

end
