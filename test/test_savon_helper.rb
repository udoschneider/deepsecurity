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

  def test_name_without_namespace
    assert_equal "HostDetail", DeepSecurity::HostDetail.name_without_namespace
  end
end