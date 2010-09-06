require 'test/unit'
require 'lib/typhon/compiler'

class TC_Compiler < Test::Unit::TestCase
  def setup
  end

  def test_push
    res = Typhon::Compiler.compile("aaaa@a@\n")
    assert_equal([:push, 5], res.pop)
  end

  def test_push2
    res = Typhon::Compiler.compile("aaa@aa@aaa\n")
    assert_equal([:push, 72], res.pop)
  end

  def test_charout
    res = Typhon::Compiler.compile("@ aa")
    assert_equal([:char_out], res.pop)
  end
end
