require "front_matter_parser"
require "hashie"

module Statique
  class Document
    attr_reader :file, :meta, :content

    def initialize(file)
      parsed = FrontMatterParser::Parser.parse_file(file)
      @file, @meta, @content = file.freeze, Hashie::Mash.new(parsed.front_matter).freeze, parsed.content.freeze
    end

    def mount_point
      case basename
      when "index.slim" then "/"
      else
        "/#{basename.delete_suffix(extname).delete_prefix(Statique.content.to_s)}"
      end.freeze
    end

    def view_name
      basename.delete_suffix(extname).freeze
    end

    def engine_name
      extname.delete_prefix(".").freeze
    end

    def layout_name
      meta.fetch("layout") { "layout" }.freeze
    end

    def title
      meta.title.freeze
    end

    private

    def basename
      @basename ||= file.basename.to_s.freeze
    end

    def extname
      @extname ||= file.extname.to_s.freeze
    end
  end
end
