# frozen_string_literal: true

require "front_matter_parser"
require "hashie"
require "pathname"
require "singleton"
require "tty-logger"

::FrontMatterParser::SyntaxParser::Builder = FrontMatterParser::SyntaxParser::MultiLineComment["=begin", "=end"]

$LOAD_PATH.unshift(File.expand_path("..", __FILE__))

require "statique/cli"

class Statique
  include Singleton
  extend Forwardable

  class Error < StandardError; end

  autoload :Configuration, "statique/configuration"
  autoload :Discover, "statique/discover"
  autoload :Document, "statique/document"
  autoload :Paginator, "statique/paginator"
  autoload :VERSION, "statique/version"

  def_delegators :configuration, :root_url

  attr_reader :configuration, :discover, :pwd, :build_queue

  def initialize
    @configuration = Configuration.new
    @discover = Discover.new(configuration.paths.content, self)
    @pwd = Pathname.pwd.freeze
  end

  def statique
    self.class.instance
  end

  def version
    VERSION
  end

  def ui
    self.class.ui
  end

  def self.ui
    @ui ||= TTY::Logger.new(output: $stdout) do |config|
      config.level = :debug if ENV["DEBUG"] == "true"
    end
  end

  def url(document_or_path)
    File.join(configuration.root_url, document_or_path.is_a?(Document) ? document_or_path.path : document_or_path)
  end
end
