# frozen_string_literal: true

require_relative "lib/test_balancer/version"

Gem::Specification.new do |spec|
  spec.name = "test_balancer"
  spec.version = TestBalancer::VERSION
  spec.authors = ["Philipp Winkler"]
  spec.email = ["winkler@webit.de"]

  spec.summary = "Handle test balancing between multiple CI nodes."
  spec.description = "Handle test balancing between multiple CI nodes."
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_dependency "dry-cli"
  spec.add_dependency "minitest-reporters"
  spec.add_dependency "nokogiri"
  spec.add_dependency "rainbow"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
