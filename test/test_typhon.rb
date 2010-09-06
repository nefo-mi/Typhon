$LOAD_PATH.unshift File.expand_path("../lib", File.dirname(__FILE__))
require 'test/unit'
require 'lib/typhon'

class TC_Typhon < Test::Unit::TestCase
  def test_hoge
    Typhon::run("aaaa@a@a\n@ a@   ")
  end
end
