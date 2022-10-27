module Logging
  def logger
    @logger ||= Logging.logger_for(self.class.name)
  end

  # Use a hash class-ivar to cache a unique Logger per class:
  @loggers = {}

  class << self
    def logger_for(classname)
      @loggers[classname] ||= configure_logger_for(classname)
    end

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

    def configure_logger_for(classname)
      logger = Logger.new($stdout, datetime_format: "%Y-%m-%d %H:%M:%S")
      logger.level = get_logger_level
      logger.progname = classname
      logger
    end
  end
end
