# frozen_string_literal: true

class Statique
  class Paginator
    attr_reader :page, :documents, :total_pages, :total_documents

    def self.per_page
      @per_page ||= 10
    end

    def initialize(documents, path, page, statique = Statique.instance)
      @path, @page = path, [page.to_i, 1].max

      @statique = statique

      @total_documents = documents.size
      @offset = (self.class.per_page * (@page - 1))
      @total_pages = (@total_documents.to_f / self.class.per_page).ceil
      @documents = documents[@offset, self.class.per_page]
    end

    def per_page
      self.class.per_page
    end

    def previous_page
      page = [1, @page - 1].max
      if page == @page
        nil
      else
        page
      end
    end

    def previous_page_path
      page_path(previous_page)
    end

    def next_page
      page = [@total_pages.zero? ? 1 : @total_pages, @page + 1].min
      if page == @page
        nil
      else
        page
      end
    end

    def next_page_path
      page_path(next_page)
    end

    private

    def page_path(page)
      return unless page

      if page == 1
        @statique.url(File.join(@path))
      else
        @statique.url(File.join(@path, "page", page.to_s))
      end
    end
  end
end
