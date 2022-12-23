# The Logging functionality which is used by classes within the app
module Logging
  # Return a logger object
  #
  # @return [Logging] the logging object
  def logger
    @logger ||= Logging.logger_for(self.class.name)
  end

  # Return a logger object for modules
  #
  # @return [Logging] the logging object
  def module_logger
    @logger ||= Logging.logger_for("HelperModule")
  end

  # Use a hash class-ivar to cache a unique Logger per class:
  @loggers = {}

  # The logging class
  class << self
    # Store the name of the class or module that is logging
    #
    # @param classname [String] the name of the class that is logging
    # @return [Hash] a cache to store a unique Logger per class
    def logger_for(classname)
      @loggers[classname] ||= configure_logger_for(classname)
    end

    # Return the log level for the class or module that is logging.
    # The log level is based on the ENV variable LOG_LEVEL
    #
    # @return [Array<Logger::Severity>] the logging level to use
    def get_logger_level
      logger_levels = {
        "debug" => Logger::DEBUG,
        "info" => Logger::INFO,
        "warning" => Logger::WARN,
        "error" => Logger::ERROR,
        "fatal" => Logger::FATAL
      }

      logger_levels[ENV.fetch("LOG_LEVEL", "warning")]
    end

    # Create and configure a logger object for the class or module that is logging.
    #
    # @return [Logger] the logger object
    def configure_logger_for(classname)
      logger = Logger.new($stdout, datetime_format: "%Y-%m-%d %H:%M:%S")
      logger.level = get_logger_level
      logger.progname = classname
      logger
    end
  end
end
