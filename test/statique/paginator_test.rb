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
end
