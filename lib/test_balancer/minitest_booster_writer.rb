require "json"

class TestBalancer::MinitestBoosterWriter
  private

  attr_reader :destination_file_path

  public

  def initialize(destination_file_path:)
    @destination_file_path = destination_file_path
  end

  # @param subsets [Hash]
  # example:
  # [
  #   subset_1: { time: 1.0, tests: ['test/first_test.rb', 'test/second_test.rb', 'test/third_test.rb'] },
  #   subset_2: { time: 1.0, tests: ['test/fourth_test.rb', 'test/fifth_test.rb', 'test/sixth_test.rb'] }
  # ]
  # return [File]
  # example:
  # minitest_split.json
  # [
  #   { "files": ["test/first_test.rb", "test/second_test.rb", "test/third_test.rb"] },
  #   { "files": ["test/fourth_test.rb", "test/fifth_test.rb", "test/sixth_test.rb"] }
  # ]
  def call(subsets:)
    File.open(destination_file_path, "w") do |file|
      file.write(subsets.map { |_, subset| { files: subset[:tests] } }.to_json)
    end
  end
end
