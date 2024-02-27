require "test_helper"

module SampleTests
  class SampleTestTwoTest < Minitest::Test
    def test_one
      sleep 2
    end

    def test_two
      sleep 4
    end
  end
end
