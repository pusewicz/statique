# frozen_string_literal: true

require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/test_*.rb"]
end

require "standard/rake"

task default: %i[test standard]

namespace :docker do
  desc "Build docker image"
  task :build do
    require "shellwords"
    require_relative "lib/statique/version"

    cmd = [
      "docker",
      "buildx",
      "build",
      "--tag", "pusewicz/statique:#{Statique::VERSION}",
      "--tag", "pusewicz/statique:latest",
      "--build-arg", "RUBY_VERSION=#{File.read(".ruby-version").chomp}",
      "--build-arg", "STATIQUE_VERSION=#{Statique::VERSION}",
      "--platform", "linux/amd64,linux/arm64",
      "."
    ]

    puts cmd.shelljoin
    system cmd.shelljoin
  end
end
