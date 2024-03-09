# frozen_string_literal: true

require "test_helper"

module TestBalancer
  class AverageExecutionTimeCalculatorTest < Minitest::Test
    def test_medianize_for_single_execution_time
      median_distributor = ::TestBalancer::AverageExecutionTimeCalculator.new
      median_distributor.add_test_cases(
        tests_with_execution_time: [
          { test_path: "test/first_test.rb", execution_time: 0.1 },
          { test_path: "test/second_test.rb", execution_time: 0.2 }
        ]
      )
      result = median_distributor.medianize

      assert_execution_times(result:, time1: 0.1, time2: 0.2)
    end

    def test_medianize_for_multiple_execution_times
      median_distributor = create_multiple_execution_times
      result = median_distributor.medianize

      assert_execution_times(result:, time1: 11, time2: 12)
    end

    def test_trimean_time_for_multiple_execution_times
      median_distributor = create_multiple_execution_times
      result = median_distributor.trimeanize

      assert_execution_times(result:, time1: 19.0, time2: 19.75)
    end

    def test_medianize_raises_error_when_no_test_cases_added
      median_distributor = ::TestBalancer::AverageExecutionTimeCalculator.new
      assert_raises ::TestBalancer::AverageExecutionTimeCalculator::AverageExecutionTimeCalculatorError do
        median_distributor.medianize
      end
    end

    def test_trimeanize_raises_error_when_no_test_cases_added
      median_distributor = ::TestBalancer::AverageExecutionTimeCalculator.new
      assert_raises ::TestBalancer::AverageExecutionTimeCalculator::AverageExecutionTimeCalculatorError do
        median_distributor.trimeanize
      end
    end

    private

    def assert_execution_times(result:, time1:, time2:)
      assert_equal time1, result[0][:execution_time]
      assert_equal time2, result[1][:execution_time]
    end

    def create_multiple_execution_times # rubocop:disable Metrics/MethodLength
      median_distributor = ::TestBalancer::AverageExecutionTimeCalculator.new
      median_distributor.add_test_cases(
        tests_with_execution_time: [
          { test_path: "test/first_test.rb", execution_time: 5 },
          { test_path: "test/second_test.rb", execution_time: 3 }
        ]
      )
      test_paths = %w[test/first_test.rb test/second_test.rb]
      execution_times = [
        [1, 2],
        [1, 2],
        [4, 5],
        [6, 7],
        [8, 9],
        [10, 11],
        [12, 13],
        [14, 15],
        [16, 17],
        [49, 50],
        [51, 52],
        [51, 52],
        [51, 52]
      ]
      execution_times.length.times do |i|
        median_distributor.add_test_cases(
          tests_with_execution_time: [
            { test_path: test_paths[0], execution_time: execution_times[i][0] },
            { test_path: test_paths[1], execution_time: execution_times[i][1] }
          ]
        )
      end
      median_distributor
    end
  end
end
