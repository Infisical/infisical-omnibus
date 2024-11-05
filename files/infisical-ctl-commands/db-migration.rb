require 'optparse'

add_command_under_category 'migration', 'database', 'Database operations', 2 do |*args|
  # discard first migration sub command
  args.shift

  subtext = <<~HELP
    Command available available:

    up       : Runs the next migration that hasn't been applied yet.
    down     : Reverts the most recent migration, undoing its changes.
    list     : Lists all available migration files without applying them.
    status   : Displays the status of each migration, showing which have been applied.
    latest   : Applies all pending migrations to bring the database up to date.
    rollback : Reverts all applied migrations, returning the database to its initial state.

    See 'infisical-ctl migration COMMAND --help' for more information on a specific command.
  HELP

  opt_parser = OptionParser.new do |opts|
    opts.banner = 'Usage: infisical-ctl migration [subcommand [options]]'
    opts.separator ''
    opts.separator subtext

    opts.on('-h', '--help', 'Prints help information') do
      puts opts
      exit
    end
  end

  db_connection_key_name = 'DB_CONNECTION_URI'
  db_connection_key_file = "/opt/infisical/etc/infisical_core/env/#{db_connection_key_name}"
  db_connection_value = ''

  if ENV[db_connection_key_name]
    puts "Loading DB connection from env #{db_connection_key_name}"
    db_connection_value = ENV[db_connection_key_name]
  elsif File.exist?(db_connection_key_file)
    db_connection_value = File.read(db_connection_key_file).strip
    puts "Loaded DB connection URI from file: #{db_connection_uri}"
  else
    puts 'DB Connection URI not found'
    exit 1
  end

  command = args.shift
  opt_parser.parse!(args)

  valid_subcommands = %w[up down list status latest rollback]
  if valid_subcommands.include?(command)
    Dir.chdir('/opt/infisical/server') do
      system({ 'DB_CONNECTION_URI' => db_connection_value,
               'PATH' => "#{ENV['PATH']}:/opt/infisical/embedded/bin" }, "npm run migration:#{command}")
    end
  else
    puts "Unknown command: #{command}"
    puts opt_parser
    exit 1
  end
end
