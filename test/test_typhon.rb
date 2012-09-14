# encoding : utf-8
$LOAD_PATH.unshift File.expand_path("../lib", File.dirname(__FILE__))
$LOAD_PATH.unshift File.expand_path("./", File.dirname(__FILE__))
require 'typhon'
require 'typhontest'

class TC_Typhon < Test::Unit::TestCase
  def test_push
    res = display_capture do
      Typhon::run("aaaa@a@a\n@ a@   ")
    end
    assert_equal([10], res)
  end

  def test_hi
    res = display_capture do
      Typhon::run("aaa@aa@aaa\n@ aaaaa@@a@aa@\n@ aa   ")
    end
    assert_equal(["H", "i"], res)
  end

  def test_parseError
    msg = "どの命令にもマッチしませんでした(7)"
    assert_raise_with_message(Typhon::Compiler::ProgramError, msg) do
      Typhon::run("@ @@@@@@")
    end
  end

  def test_error_heap_read
    msg = "ヒープの未初期化の位置を読みだそうとしました。(address = 1)"
    assert_raise_with_message(Typhon::VM::ProgramError, msg) do
      Typhon::run("aaa@\n@@@   ")
    end
  end

  def test_error_exit
    msg = "プログラムの最後はexit命令を実行してください"
    assert_raise_with_message(Typhon::VM::ProgramError, msg) do
      Typhon::run("aaa@\n")
    end
  end

  def test_error_pop
    msg = "空のスタックをポップしようとしました"
    assert_raise_with_message(Typhon::VM::ProgramError, msg) do
      Typhon::run("@ a@")
    end
  end

  def test_error_jump
    name ="@@@"
    msg = "ジャンプ先(#{name.inspect})が見つかりません。"
    assert_raise_with_message(Typhon::VM::ProgramError, msg) do
      Typhon::run(" a " + name + "\n   ")
    end
  end

  def test_error_return
    msg = "サブルーチンの外からreturnしようとしました"
    assert_raise_with_message(Typhon::VM::ProgramError, msg) do
      Typhon::run(" @ ")
    end
  end
end
