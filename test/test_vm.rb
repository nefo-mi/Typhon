require 'test/unit'
require 'lib/typhon/vm'

class TC_VM < Test::Unit::TestCase
  def test_hoge
    res = Typhon::VM.run([[:push, 1], [:num_out], [:exit]])
    assert_equal(1, res)
  end
end
