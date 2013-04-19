require 'test/unit'
require 'deepsecurity'

class TestSudoku < Test::Unit::TestCase
  def test_blank
    assert_equal false, "abc".blank?
    assert_equal true, "".blank?
    assert_equal true, nil.blank?
  end

  def test_name_without_namespace
    assert_equal "HostDetail", DeepSecurity::HostDetail.name_without_namespace
  end
end