class TestBalancer::AverageExecutionTimeCalculator
  class AverageExecutionTimeCalculatorError < StandardError; end

  private

  attr_reader :test_cases, :test_cases_id

  public

  def initialize
    @test_cases = {}
    @test_cases_id = 0
  end

  # @param tests_with_execution_time [Array<Hash>]
  # example: [{ test_path: 'test/first_test.rb', execution_time: 0.1 }, { test_path: 'test/second_test.rb', execution_time: 0.2 }]
  # return void
  def add_test_cases(tests_with_execution_time:)
    @test_cases[test_cases_id] = tests_with_execution_time
    @test_cases_id += 1
  end

  def reset
    @test_cases = {}
    @test_cases_id = 0
  end

  # return [Array<Hash>]
  # example: [{ test_path: 'test/first_test.rb', execution_time: 0.1 }, { test_path: 'test/second_test.rb', execution_time: 0.2 }]
  def medianize
    raise AverageExecutionTimeCalculatorError, "No test cases added" if test_cases.empty?

    result = []

    test_cases[0].each do |test_case|
      test_path = test_case[:test_path]
      result << { test_path:, execution_time: median_time_for_test_path(test_path:) }
    end

    result
  end

  # return [Array<Hash>]
  # example: [{ test_path: 'test/first_test.rb', execution_time: 0.1 }, { test_path: 'test/second_test.rb', execution_time: 0.2 }]
  def trimeanize
    raise AverageExecutionTimeCalculatorError, "No test cases added" if test_cases.empty?

    result = []

    test_cases[0].each do |test_case|
      test_path = test_case[:test_path]
      result << { test_path:, execution_time: trimean_time_for_test_path(test_path:) }
    end

    result
  end

  private

  def median_time_for_test_path(test_path:)
    test_case_execution_times = @test_cases.map do |_, test_cases|
      test_cases.find { |test_case| test_case[:test_path] == test_path }[:execution_time]
    end

    median(numbers: test_case_execution_times)
  end

  def trimean_time_for_test_path(test_path:)
    test_case_execution_times = @test_cases.map do |_, test_cases|
      test_cases.find { |test_case| test_case[:test_path] == test_path }[:execution_time]
    end

    trimean(numbers: test_case_execution_times)
  end

  def median(numbers:)
    return nil if numbers.empty?

    sorted = numbers.sort
    len = sorted.length
    (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0
  end

  def trimean(numbers:)
    numbers.sort!
    n = numbers.length
    q1 = quantile(numbers:, p: 0.25)
    q3 = quantile(numbers:, p: 0.75)
    m = median(numbers:)
    lower_half = numbers.select { |x| x <= m }
    upper_half = numbers.select { |x| x >= m }
    t1 = median(numbers: lower_half)
    t2 = median(numbers: upper_half)
    (t1 + 2 * m + t2) / 4.0
  end

  def quantile(numbers:, p:)
    n = numbers.length
    k = (n * p).floor
    if k < 1
      numbers.first
    elsif k >= n
      numbers.last
    else
      d = n * p - k
      numbers[k - 1] + d * (numbers[k] - numbers[k - 1])
    end
  end
end
