require "dry/cli"

module TestBalancer::Cli::Commands
  extend Dry::CLI::Registry

  register "from_xmls", FromXmls
  register "from_xmls_with_multiple_test_executions", FromXmlsWithMultipleTestExecutions
end
