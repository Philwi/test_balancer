# frozen_string_literal: true

require "test_helper"
require "json"

module TestBalancer
  class TestBalancerTest < Minitest::Test
    def test_balancing_tests_with_huge_peak
      result = call_test_balancer(third_exection_time: 25.3, subset_count: 4)

      assert_subset(result, :subset_1, 25.3, ["test/third_test.rb"])
      assert_subset(result, :subset_2, 4.7, ["test/fourth_test.rb"])
      assert_subset(result, :subset_3, 2.4, ["test/tenth_test.rb", "test/seventh_test.rb", "test/sixth_test.rb", "test/first_test.rb"])
      assert_subset(result, :subset_4, 2.4, ["test/ninth_test.rb", "test/eighth_test.rb", "test/fifth_test.rb", "test/second_test.rb"])
    end

    def test_balancing_tests_with_almost_equally_distributed_execution_times
      result = call_test_balancer(third_exection_time: 2, subset_count: 3)

      assert_subset(result, :subset_1, 4.7, ["test/fourth_test.rb"])
      assert_subset(result, :subset_2, 3.4, ["test/third_test.rb", "test/seventh_test.rb", "test/sixth_test.rb", "test/first_test.rb"])
      assert_subset(result, :subset_3, 3.4)
    end

    def test_with_huge_amount_of_tests
      result = call_test_balancer_with_huge_amount_of_tests
      assert_equal 4, result.keys.count
    end

    def test_with_sample_output
      sample_json = File.read("test/sample_output.json")
      sample_output = JSON.parse(sample_json, symbolize_names: true)
      result = test_balancer.call(tests_with_execution_time: sample_output, subset_count: 3)

      assert_subset(result, :subset_1, 9.5, ["test/sample_tests/sample_test_three_test.rb"])
      assert_subset(result, :subset_2, 6.0, ["test/sample_tests/sample_test_two_test.rb"])
      assert_subset(result, :subset_3, 4.1, ["test/sample_tests/sample_test_one_test.rb", "test/lib/test_balancer/test_balancer_test.rb"])
    end

    private

    def call_test_balancer(third_exection_time:, subset_count:)
      test_balancer.call(tests_with_execution_time: example_tests(third_exection_time:), subset_count:)
    end

    def call_test_balancer_with_huge_amount_of_tests
      examples = []
      10_000.times do |index|
        examples << { test_path: "test/#{index}_test.rb", execution_time: rand(0.1..10.0) }
      end

      test_balancer.call(tests_with_execution_time: examples, subset_count: 4)
    end

    def assert_subset(result, subset, time, tests = [])
      assert_equal time, result[subset][:time].round(1)
      assert_equal tests, result[subset][:tests] unless tests.empty?
    end

    def test_balancer
      ::TestBalancer::TestBalancer.new
    end

    def example_tests(third_exection_time: 2) # rubocop:disable Metrics/MethodLength
      [
        { test_path: "test/first_test.rb", execution_time: 0.1 },
        { test_path: "test/second_test.rb", execution_time: 0.2 },
        { test_path: "test/third_test.rb", execution_time: third_exection_time },
        { test_path: "test/fourth_test.rb", execution_time: 4.7 },
        { test_path: "test/fifth_test.rb", execution_time: 0.5 },
        { test_path: "test/sixth_test.rb", execution_time: 0.6 },
        { test_path: "test/seventh_test.rb", execution_time: 0.7 },
        { test_path: "test/eighth_test.rb", execution_time: 0.8 },
        { test_path: "test/ninth_test.rb", execution_time: 0.9 },
        { test_path: "test/tenth_test.rb", execution_time: 1.0 }
      ]
    end
  end
end
# rubocop:enable Naming/VariableNumber
