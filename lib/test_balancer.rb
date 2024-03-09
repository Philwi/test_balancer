# frozen_string_literal: true

require "pry"

require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.setup # ready!

module TestBalancer
  class Error < StandardError; end

  def self.calculate_distributed_tests_from_xml_files(xml_files:, subset_count:)
    tests_with_execution_time = xml_files.map do |xml_file|
      ::TestBalancer::ExecutionTimeXmlParser.new(xml_file_path: xml_file).call
    end
    ::TestBalancer::TestBalancer.new.call(tests_with_execution_time:, subset_count:)
  end

  def self.write_subsets_to_minitest_booster_file(subsets:, destination_file_path: 'minitest_split.json')
    ::TestBalancer::MinitestBoosterWriter.new(destination_file_path:).call(subsets:)
  end
end
