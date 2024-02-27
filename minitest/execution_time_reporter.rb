require "json"

module Minitest
  class ExecutionTimeReporter < Minitest::Reporters::BaseReporter
    def initialize(options = {})
      @execution_times_per_file = {}
      super(options)
    end

    def record(test)
      test_file_path = test.source_location.first
      @execution_times_per_file[test_file_path] ||= 0
      @execution_times_per_file[test_file_path] += test.time
      super
    end

    def report
      File.open("execution_times.json", "w") do |file|
        file.write(transform_to_output.to_json)
      end
    end

    private

    def transform_to_output
      @execution_times_per_file.map do |file, time|
        { test_path: file, execution_time: time }
      end
    end
  end
end
