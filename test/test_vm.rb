require 'test/unit'
require 'lib/typhon/vm'

class TC_VM < Test::Unit::TestCase
  def test_hoge
    assert_block(message="1") do
      Typhon::VM.run([[:push, 1], [:num_out], [:exit]])
    end
  end
end
