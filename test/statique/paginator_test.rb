# frozen_string_literal: true

require "test_helper"

class TestPaginator < Minitest::Spec
  it "initialize" do
    paginator = Statique::Paginator.new([1, 2, 3, 4, 5], "/path", "1")
    expect(paginator.page).must_equal(1)
    expect(paginator.total_documents).must_equal(5)
    expect(paginator.total_pages).must_equal(1)
    expect(paginator.documents).must_equal([1, 2, 3, 4, 5])
    expect(paginator.per_page).must_equal(10)
  end

  it "defaults page to 1 on init" do
    expect(Statique::Paginator.new([], "/", "").page).must_equal(1)
    expect(Statique::Paginator.new([], "/", "0").page).must_equal(1)
    expect(Statique::Paginator.new([], "/", "abc").page).must_equal(1)
    expect(Statique::Paginator.new([], "/", 0).page).must_equal(1)
    expect(Statique::Paginator.new([], "/", nil).page).must_equal(1)
  end

  it "sets page to integer of the passed value" do
    expect(Statique::Paginator.new([], "/", "3").page).must_equal(3)
    expect(Statique::Paginator.new([], "/", 4).page).must_equal(4)
  end

  it "#previous_page returns nil if there is no previous page" do
    paginator = Statique::Paginator.new([], "/", "1")
    expect(paginator.previous_page).must_be_nil
  end

  it "#previous_page returns page if there is previous page" do
    paginator = Statique::Paginator.new([1, 2], "/", "2")
    expect(paginator.previous_page).must_equal(1)
  end

  it "#next_page returns nil if there is no previous page" do
    paginator = Statique::Paginator.new([], "/", "1")
    expect(paginator.next_page).must_be_nil
  end

  it "#next_page returns page if there is previous page" do
    paginator = Statique::Paginator.new([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "/", "1")
    expect(paginator.next_page).must_equal(2)
  end

  it "#next_page_path returns the current path with page argument" do
    paginator = Statique::Paginator.new([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "/path", "1")
    expect(paginator.next_page_path).must_equal("/path/page/2")
  end

  it "#previous_page_path returns the current path with page argument" do
    paginator = Statique::Paginator.new((1..30).to_a, "/path", "3")
    expect(paginator.previous_page_path).must_equal("/path/page/2")
  end

  it "#previous_page_path returns the current path with no page argument if it's the first page" do
    paginator = Statique::Paginator.new((1..30).to_a, "/path", "2")
    expect(paginator.previous_page_path).must_equal("/path")
  end

  it "#next_page_path returns nil if there's no path" do
    paginator = Statique::Paginator.new((1..3).to_a, "/path", "1")
    expect(paginator.next_page_path).must_be_nil
  end

  it "#previous_page_path returns nil if there's no path" do
    paginator = Statique::Paginator.new((1..3).to_a, "/path", "1")
    expect(paginator.previous_page_path).must_be_nil
  end
end
