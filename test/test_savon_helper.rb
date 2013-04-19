require 'test/unit'
require 'deepsecurity'

class TestSudoku < Test::Unit::TestCase
  def test_blank
    assert_equal false, "abc".blank?
    assert_equal true, "".blank?
    assert_equal true, nil.blank?
  end
end