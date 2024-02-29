require "test_helper"

class TestBalancerTest < Minitest::Test
  def setup
    @xml_files = Dir["test/sample_xmls/*.xml"]
  end

  def test_parsing_xmls
    result = TestBalancer.calculate_distributed_tests_from_xml_files(xml_files: @xml_files, subset_count: 3)
    assert_equal 3, result.keys.count
    assert_equal 1, result[:subset_1][:tests].count
  end

  def test_getting_execution_time_from_xmls
    result = TestBalancer.calculate_distributed_tests_from_xml_files(xml_files: @xml_files, subset_count: 2)
    assert_subset(result, :subset_1, 28.8, ["test/system/foo_test.rb"])
  end

  private

  def assert_subset(result, subset, time, tests = [])
    assert_equal time, result[subset][:time].round(1)
    assert_equal tests, result[subset][:tests] unless tests.empty?
  end
end
