# frozen_string_literal: true

require "minitest/autorun"
require "minitest/reporters"
require_relative "../lib/test_balancer"
require_relative "../minitest/execution_time_reporter"

Minitest::Reporters.use! [TestBalancer::ExecutionTimeReporter.new] if ENV["WRITE_EXECUTION_TIME_FILE"]
