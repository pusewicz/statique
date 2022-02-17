# frozen_string_literal: true

require_relative "lib/statique/version"

Gem::Specification.new do |spec|
  spec.name = "statique"
  spec.version = Statique::VERSION
  spec.authors = ["Piotr Usewicz"]
  spec.email = ["piotr@layer22.com"]

  spec.summary = "Static website generator"
  spec.description = "Statique is a static website generator written in Ruby using Roda"
  spec.homepage = "https://github.com/pusewicz/statique"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/pusewicz/statique"
  spec.metadata["changelog_uri"] = "https://raw.githubusercontent.com/pusewicz/statique/v#{spec.version}/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "builder", "~> 3.2.4"
  spec.add_dependency "commonmarker", "~> 0.23.2"
  spec.add_dependency "filewatcher", "~> 1.1.1"
  spec.add_dependency "front_matter_parser", "~> 1.0.1"
  spec.add_dependency "hashie", "~> 5.0.0"
  spec.add_dependency "memo_wise", "~> 1.6.0"
  spec.add_dependency "roda", "~> 3.53"
  spec.add_dependency "slim", "~> 4.1.0"
  spec.add_dependency "thor", "~> 1.2.1"
  spec.add_dependency "tilt", "~> 2.0.10"
  spec.add_dependency "tty-logger", "~> 0.6.0"
  spec.add_dependency "webrick", "~> 1.7.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
