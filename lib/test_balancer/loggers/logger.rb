module TestBalancer::Loggers
  class Logger
    attr_reader :output, :level

    LEVELS = %i[info warn error].freeze

    def initialize(output, level: :info)
      @output = output
      @level = level
    end

    def info(message)
      output.puts "INFO: #{message}" if should_log?(message_log_level: :info)
    end

    def warn(message)
      output.puts "WARNING: #{message}" if should_log?(message_log_level: :warn)
    end

    def error(message)
      output.puts "ERROR: #{message}" if should_log?(message_log_level: :error)
    end

    private

    def should_log?(message_log_level:)
      return true if LEVELS.index(message_log_level) >= LEVELS.index(level)

      false
    end
  end
end
