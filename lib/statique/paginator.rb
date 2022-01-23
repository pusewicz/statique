# frozen_string_literal: true

class Statique
  class Paginator
    attr_reader :documents

    def initialize(pagy, documents, path)
      @pagy, @documents, @path = pagy, documents, path
    end

    def page
      @pagy.page
    end

    def total_pages
      @pagy.pages
    end

    def total_documents
      @pagy.count
    end

    def previous_page
      @pagy.prev
    end

    def previous_page_path
      page_path(@pagy.prev)
    end

    def next_page
      @pagy.next
    end

    def next_page_path
      page_path(@pagy.next)
    end

    def per_page
      @pagy.items
    end

    private

    def page_path(page)
      return unless page

      if page == 1
        Statique.url(File.join(@path))
      else
        Statique.url(File.join(@path, "page", page.to_s))
      end
    end
  end
end
