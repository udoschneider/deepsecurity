require 'test/unit'
require 'deepsecurity'

class TestSavonHelper < Test::Unit::TestCase
  def test_blank
    assert_equal false, "abc".blank?
    assert_equal true, "".blank?
    assert_equal true, nil.blank?
  end

  def test_strip_comments
    assert_equal "test", "test".strip_comments
    assert_equal "test ", "test #123".strip_comments
    assert_equal "", "#123".strip_comments
  end
end