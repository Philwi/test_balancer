# frozen_string_literal: true

require "test_helper"

module TestBalancer
  class TestBalancerTest < Minitest::Test
    def test_balancing_test_with_subset_of_4
      result = test_balancer.call(tests_with_execution_time: example_tests, subset_count: 4)

      assert_equal 25.3, result[:subset_1][:time].to_f
      assert_equal ["test/third_test.rb"], result[:subset_1][:tests]
      assert_equal 4.7, result[:subset_2][:time].to_f
      assert_equal ["test/fourth_test.rb"], result[:subset_2][:tests]
      assert_equal 2.4, result[:subset_3][:time].to_f
      assert_equal ["test/tenth_test.rb", "test/seventh_test.rb", "test/sixth_test.rb", "test/first_test.rb"],
                   result[:subset_3][:tests]
      assert_equal 2.4, result[:subset_4][:time].to_f.round(1)
      assert_equal ["test/ninth_test.rb", "test/eighth_test.rb", "test/fifth_test.rb", "test/second_test.rb"],
                   result[:subset_4][:tests]
    end

    private

    def test_balancer
      TestBalancer::TestBalancer.new
    end

    def example_tests
      [
        { test_path: "test/first_test.rb", execution_time: 0.1 },
        { test_path: "test/second_test.rb", execution_time: 0.2 },
        { test_path: "test/third_test.rb", execution_time: 25.3 },
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
