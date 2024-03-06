module TestBalancer::Cli::Commands
  class FromXmls < Dry::CLI::Command
    desc "Generate test subsets from XML files and write it to minitest_split.json."

    argument :xml_path, desc: "Folder with XML files to parse", required: true, type: :string

    option :subsets, desc: "Number of subsets to generate", default: 1, type: :integer

    example [
      "test_balancer from_xmls file1.xml file2.xml",
      "test_balancer from_xmls file1.xml file2.xml --subsets 3"
    ]

    def call(xml_path:, **options)
      file_paths = Dir.glob("#{xml_path}/*.xml")
      subsets = options[:subsets].to_i
      raise "No XML files found in #{xml_path}" if file_paths.empty?

      puts "Generating test suite for #{file_paths.join(" ,")} with #{subsets} subsets"

      result = TestBalancer.calculate_distributed_tests_from_xml_files(xml_files: file_paths, subset_count: subsets)
      puts "Writing subsets to minitest_split.json"
      TestBalancer.write_subsets_to_minitest_booster_file(subsets: result)
      puts "Done"
    end
  end
end
