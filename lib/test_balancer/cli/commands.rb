require "dry/cli"

module TestBalancer::Cli::Commands
  extend Dry::CLI::Registry

  register "from_xmls", FromXmls
end
