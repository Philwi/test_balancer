# frozen_string_literal: true

module TestBalancer
  class TestBalancer
    # @param tests_with_execution_time [Array<Hash>]
    # example: [{ test_path: 'test/first_test.rb', execution_time: 0.1 }, { test_path: 'test/second_test.rb', execution_time: 0.2 }]
    # @param subset_count [Integer]
    # return [Hash]
    # example:
    # {
    #   subset_1: { time: 1.0, tests: ['test/first_test.rb', 'test/second_test.rb', 'test/third_test.rb'] },
    #   subset_2: { time: 1.0, tests: ['test/fourth_test.rb', 'test/fifth_test.rb', 'test/sixth_test.rb'] },
    #   subset_3: { time: 1.0, tests: ['test/seventh_test.rb', 'test/eighth_test.rb', 'test/ninth_test.rb', 'test/tenth_test.rb'] }
    # }
    def call(tests_with_execution_time:, subset_count: 2)
      tests_with_execution_time = tests_with_execution_time.map { |test| test.transform_keys(&:to_sym) }
      tests = tests_with_execution_time.sort_by { |test| test[:execution_time] }.reverse
      assign_tests_to_subsets(tests, subset_count)
    end

    private

    def assign_tests_to_subsets(tests, subset_count)
      subsets = init_subsets(subset_count:)
      tests.each do |test|
        subset = subsets.min_by { |_, subset_hash| subset_hash[:time] }[0]
        subsets[subset][:time] += test[:execution_time]
        subsets[subset][:tests] << test[:test_path]
      end
      subsets
    end

    def init_subsets(subset_count:)
      subsets = {}
      subset_count.times do |i|
        subsets["subset_#{i + 1}".to_sym] = { time: 0, tests: [] }
      end
      subsets
    end
  end
end
