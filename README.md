# TestBalancer

## Installation

Add to the application's Gemfile:

    gem 'test_balancer', github: 'Philwi/test_balancer', branch: 'main'

## Usage

Add to the minitest test_helper.rb file:

    require 'minitest/reporters'
    Minitest::Reporters.use! [TestBalancer::ExecutionTimeReporter.new] if ENV["WRITE_EXECUTION_TIME_FILE"]

Run your tests with the environment variable `WRITE_EXECUTION_TIME_FILE` set to `true`:

    WRITE_EXECUTION_TIME_FILE=true bundle exec rake test

This will create a file `execution_times.json` in the root of the application. This file contains the execution times of the tests in the last test run.

To balance the tests for multiple CI-Nodes use the `TestBalancer::TestBalancer` class:

    file = File.read('execution_times.json')
    tests_with_execution_time = JSON.parse(file)
    test_balancer = TestBalancer::TestBalancer.new
    test_balancer.call(tests_with_execution_time: tests_with_execution_time, subset_count: 2)

Now you get a list of distributed test files for the two CI-Nodes:

    [
        { :subset_1=>{:time=>9.509755814999153, :tests=>["test/sample_tests/sample_test_one_test.rb"] },
        { :subset_2=>{:time=>8.32, :tests=>["test/sample_tests/sample_test_two_test.rb", "test/sample_tests/sample_test_three_test.rb"] }
    ]

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/test_balancer. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/Philwi/test_balancer/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the TestBalancer project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/Philwi/test_balancer/blob/main/CODE_OF_CONDUCT.md).
