# frozen_string_literal: true

require "hashie"

class Statique
  class Document
    attr_reader :file, :meta, :content

    def initialize(file)
      parsed = FrontMatterParser::Parser.parse_file(file)
      @file, @meta, @content = file.freeze, Hashie::Mash.new(parsed.front_matter).freeze, parsed.content.freeze
    end

    def path
      case basename
      when "index.slim" then "/"
      else
        "/#{meta.permalink || basename.delete_suffix(extname).delete_prefix(Statique.paths.content.to_s)}"
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

    def body
      content
    end

    def published_at
      @published_at ||= file.ctime.freeze
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
