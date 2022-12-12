# frozen_string_literal: true

require "test_helper"

class TestStatique < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Statique::VERSION
  end

  def test_version_returns_a_string
    assert_instance_of String, Statique.instance.version
  end

  def test_instance_returns_instance
    assert_instance_of Statique, Statique.instance
    assert_equal Statique.instance, Statique.instance.statique
  end

  def test_url
    statique = Statique.instance

    assert_equal "/", statique.url("/")
    assert_equal "/another", statique.url("/another")

    document = Minitest::Mock.new
    document.expect(:is_a?, true, [Statique::Document])
    document.expect(:path, "/path/to/document")

    assert_equal "/path/to/document", statique.url(document)

    assert_mock document
  end
end
