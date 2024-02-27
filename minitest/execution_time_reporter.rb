require "json"

module Minitest
  class ExecutionTimeReporter < Minitest::Reporters::BaseReporter
    def initialize(options = {})
      @execution_times_per_file = {}
      super(options)
    end

    def record(test)
      absolute_test_file_path = test.source_location.first
      working_directory = Dir.pwd
      test_file_path = absolute_test_file_path.gsub("#{working_directory}/", "")

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
