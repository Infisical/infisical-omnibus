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

  def self.gather_infisical_secrets # rubocop:disable Metrics/AbcSize
    secret_tokens = {
      'infisical_core' => {
        'secret_key_base' => Infisical['infisical_core']['secret_key_base'],
        'db_key_base' => Infisical['infisical_rails']['db_key_base'],
        'otp_key_base' => Infisical['infisical_rails']['otp_key_base'],
        'encrypted_settings_key_base' => Infisical['infisical_rails']['encrypted_settings_key_base'],
        'openid_connect_signing_key' => Infisical['infisical_rails']['openid_connect_signing_key']
      },
      'letsencrypt' => {
        'auto_enabled' => Infisical['letsencrypt']['auto_enabled']
      },
      'postgresql' => {
        'internal_certificate' => Infisical['postgresql']['internal_certificate'],
        'internal_key' => Infisical['postgresql']['internal_key']
      }
    }

    if Infisical['mattermost']['infisical_enable']
      infisical_oauth = {
        'infisical_enable' => Infisical['mattermost']['infisical_enable'],
        'infisical_secret' => Infisical['mattermost']['infisical_secret'],
        'infisical_id' => Infisical['mattermost']['infisical_id']
      }
      secret_tokens['mattermost'].merge!(infisical_oauth)
    end

    secret_tokens
  end

  def self.write_to_infisical_secrets(path = SECRETS_FILE)
    secret_tokens = gather_infisical_secrets

    if File.directory?(File.dirname(path))
      File.open(path, 'w', 0o600) do |f|
        f.puts(Chef::JSONCompat.to_json_pretty(secret_tokens))
        f.chmod(0o600)
      end
    end

    nil
  end
end
