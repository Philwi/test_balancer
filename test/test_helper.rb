# frozen_string_literal: true

require "minitest/autorun"
require "minitest/reporters"
require_relative "../lib/test_balancer"

Minitest::Reporters.use! [TestBalancer::ExecutionTimeReporter.new] if ENV["WRITE_EXECUTION_TIME_FILE"]
