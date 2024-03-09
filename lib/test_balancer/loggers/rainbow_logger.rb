require "rainbow"

module TestBalancer::Loggers
  class RainbowLogger
    private

    attr_reader :logger

    public

    def initialize(logger: TestBalancer::Loggers::Logger.new(STDOUT))
      @logger = logger
    end

    def success(message)
      logger.info Rainbow(message).green
    end

    def error(message)
      logger.error Rainbow(message).red
    end

    def warning(message)
      logger.warn Rainbow(message).yellow
    end

    def info(message)
      logger.info Rainbow(message).blue
    end

    def section_start(message)
      logger.info Rainbow("BEGINNING: #{message} ======================================== #{message}").blue
    end

    def section_end(message)
      logger.info Rainbow("ENDING: #{message} ======================================== #{message}").blue
    end
  end
end
