# frozen_string_literal: true

require "bundler/gem_tasks"
require "minitest/test_task"
require "rubocop/rake_task"

RuboCop::RakeTask.new

Minitest::TestTask.create :test do |t|
  t.test_globs = ["test/lib/**/*_test.rb"]
  t.warning = false
end

Minitest::TestTask.create :test_with_samples do |t|
  t.test_globs = ["test/**/*_test.rb"]
  t.warning = false
end

task default: %i[rubocop test]
