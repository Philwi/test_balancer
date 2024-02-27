require "test_helper"

module SampleTests
  class SampleTestOneTest < Minitest::Test
    def test_one
      sleep 1
    end

    def test_two
      sleep 3
    end
  end
end
