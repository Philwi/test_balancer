module TestBalancer::Cli::Commands
  class FromXmls < Dry::CLI::Command
    desc "Generate test subsets from XML files and write it to minitest_split.json."

    argument :xml_path, desc: "Folder with XML files to parse", required: true, type: :string

    option :subsets, desc: "Number of subsets to generate", default: 1, type: :integer

    example [
      "test_balancer from_xmls file1.xml file2.xml",
      "test_balancer from_xmls file1.xml file2.xml --subsets 3"
    ]

    def call(xml_path:, logger: ::TestBalancer::Loggers::RainbowLogger.new, **options) # rubocop:disable Metrics/MethodLength
      logger.section_start("GENERATING TEST SUBSETS FROM XML FILES")

      file_paths = Dir.glob("#{xml_path}/**/*.xml")
      subsets = options[:subsets].to_i
      raise logger.error("No XML files found in #{xml_path}") if file_paths.empty?

      logger.info "Generating test suite for #{file_paths.join(" ,")} with #{subsets} subsets"

      result = TestBalancer.calculate_distributed_tests_from_xml_files(xml_files: file_paths, subset_count: subsets)
      logger.section_end("GENERATING TEST SUBSETS FROM XML FILES")
      logger.section_start("WRITING SUBSETS TO minitest_split.json")
      TestBalancer.write_subsets_to_minitest_booster_file(subsets: result)
      logger.section_end("WRITING SUBSETS TO minitest_split.json")
      logger.success("Successfully wrote subsets to minitest_split.json")
    end
  end
end
