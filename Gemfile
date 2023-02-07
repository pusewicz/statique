# frozen_string_literal: true

ruby File.read(File.expand_path("../.ruby-version", __FILE__)).chomp

source "https://rubygems.org"

# Specify your gem's dependencies in statique.gemspec
gemspec

group :development do
  gem "benchmark-ips"
  gem "bundle-audit", "~> 0.1.0"
  gem "minitest", "~> 5.17"
  gem "minitest-around", "~> 0.5.0"
  gem "overcommit"
  gem "rake", "~> 13.0"
  gem "rubocop-minitest", "~> 0.27.0"
  gem "rubocop-rake", "~> 0.6.0"
  gem "solargraph"
  gem "standard", "~> 1.23"
end

group :test do
  gem "simplecov", require: false
end
