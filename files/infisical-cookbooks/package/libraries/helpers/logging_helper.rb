module LoggingHelper
  extend self

  # The current set of recorded messages.  Mostly here to enable more fluent spec
  # testing.
  #
  # @return [Array<Hash{Symbol => String, nil}>]
  attr_accessor :messages

  @messages = []

  # Resets the set of recorded messages.  Mostly here to enable more fluent spec
  # testing.
  #
  # @return [void]
  def reset
    @messages = []
  end

  # Records a message the user should be informed of later.
  #
  # @param message [String] A message to give the user
  # @param kind: [:deprecation, nil]
  # @return [void]
  def log(message, kind: nil)
    @messages << {
      message: message,
      kind: kind
    }
  end

  # Records a message as a note, printed at the end of reconfigure
  #
  # @param message [String] A message to give the user
  # @return [void]
  def note(message)
    log(message, kind: :note)
  end

  # Records a message as deprecation, logging as we see it.
  #
  # @param message [String] A message to give the user
  # @return [void]
  def deprecation(message)
    Chef::Log.warn message
    log(message, kind: :deprecation)
  end

  # Records a message as removal, logging as we see it.
  #
  # @param message [String] A message to give the user
  # @return [void]
  def removal(message)
    Chef::Log.warn message
    log(message, kind: :removal)
  end

  # Records a message as warning, logging as we see it.
  #
  # @param message [String] A message to give the user
  # @return [void]
  def warning(message)
    Chef::Log.warn message
    log(message, kind: :warning)
  end

  # Records a message as debug, logging as we see it.
  #
  # @param message [String] A message to give the user
  # @return [void]
  def debug(message)
    Chef::Log.debug message
    log(message, kind: :debug)
  end

  # Prints a report for the specified message type
  #
  # @param type [Symbol] The type of message to print a report for
  # @return [true]
  def print_report(type)
    generated = @messages.select { |m| m[:kind] == type }
    return unless generated.any?

    puts
    puts "#{type.capitalize}s:"

    new_messages = generated.map { |m| m[:message] }
    puts new_messages.join("\n")
    puts

    return unless %i[removal deprecation].include?(type)

    puts 'Update the configuration in your infisical.rb file or INFISICAL_OMNIBUS_CONFIG environment.'
    puts
  end

  # Report on any messages generated during reconfigure
  def report
    %i[removal deprecation warning note].each do |type|
      print_report(type)
    end

    # code blocks in chef report callbacks are expected to yield true
    true
  end
end
