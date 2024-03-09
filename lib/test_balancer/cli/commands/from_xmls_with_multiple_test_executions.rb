module TestBalancer::Cli::Commands
  class FromXmlsWithMultipleTestExecutions < Dry::CLI::Command
    class FromXmlsWithMultipleTestExecutionsError < StandardError; end

    desc "Generate test subsets from XML files from multiple test executions and write it to minitest_split.json."

    argument(
      :test_execution_folder,
      desc: "Folder with test execution folders. Every folder is one test complete test execution suite",
      required: true,
      type: :string
    )

    option :subsets, desc: "Number of subsets to generate", default: 1, type: :integer

    example [
      "test_balancer from_xmls_with_multiple_test_executions test_execution_folder /path/to/test_execution_folder",
      "test_balancer from_xmls_with_multiple_test_executions test_execution_folder /path/to/test_execution_folder --subsets 3"
    ]

    def call(test_execution_folder:, logger: ::TestBalancer::Loggers::RainbowLogger.new, **options) # rubocop:disable Metrics/MethodLength
      logger.section_start("GENERATING AVERAGE TEST EXECUTION TIMES FOR TEST SUITES")
      ensure_test_execution_folder_exists(test_execution_folder:)

      average_execution_times = generate_average_execution_times(folder_path: test_execution_folder)
      raise FromXmlsWithMultipleTestExecutionsError, logger.error("No test execution files found in #{test_execution_folder}") if average_execution_times.empty?

      logger.section_end("GENERATING AVERAGE TEST EXECUTION TIMES FOR TEST SUITES")

      logger.section_start("GENERATING TEST SUBSETS FROM AVERAGE TEST EXECUTION TIMES")
      subset_count = options[:subsets].to_i
      result = ::TestBalancer::TestBalancer.new.call(tests_with_execution_time: average_execution_times, subset_count:)
      logger.section_end("GENERATING TEST SUBSETS FROM AVERAGE TEST EXECUTION TIMES")
      logger.section_start("WRITING SUBSETS TO minitest_split.json")
      TestBalancer.write_subsets_to_minitest_booster_file(subsets: result)
      logger.section_end("WRITING SUBSETS TO minitest_split.json")
    end

    private

    def ensure_test_execution_folder_exists(test_execution_folder:)
      raise FromXmlsWithMultipleTestExecutionsError, logger.error("No folder path given") if test_execution_folder.nil?
      raise FromXmlsWithMultipleTestExecutionsError, logger.error("No folder found at #{test_execution_folder}") unless Dir.exist?(test_execution_folder)

      true
    end

    def generate_average_execution_times(folder_path:)
      average_execution_time_calculator = TestBalancer::AverageExecutionTimeCalculator.new
      parse_test_executions(folder_path:).each do |test_execution|
        average_execution_time_calculator.add_test_cases(tests_with_execution_time: test_execution)
      end
      average_execution_time_calculator.trimeanize
    end

    def parse_test_executions(folder_path:)
      result =
        Dir.glob("#{folder_path}/*").map do |test_execution_folder|
          xml_file_paths = Dir.glob("#{test_execution_folder}/**/*.xml")

          xml_file_paths.map do |xml_file_path|
            ::TestBalancer::ExecutionTimeXmlParser.new(xml_file_path:).call
          end
        end

      result.reject(&:empty?)
    end
  end
end
