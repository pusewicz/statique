# frozen_string_literal: true

ruby file: ".ruby-version"

source "https://rubygems.org"

# Specify your gem's dependencies in statique.gemspec
gemspec

group :development do
  gem "benchmark-ips"
  gem "bundle-audit", "~> 0.1.0"
  gem "minitest", "~> 5.21"
  gem "minitest-around", "~> 0.5.0"
  gem "overcommit"
  gem "rake", "~> 13.0"
  gem "rubocop-minitest", "~> 0.34.4"
  gem "rubocop-rake", "~> 0.6.0"
  gem "solargraph"
  gem "standard", "~> 1.33"
end

group :test do
  gem "simplecov", require: false
end
