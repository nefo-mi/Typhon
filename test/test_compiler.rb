require 'test/typhontest'
require 'lib/typhon/compiler'

class TC_Compiler < Test::Unit::TestCase
  def test_push
    res = Typhon::Compiler.compile("aaaa@a@\n")
    assert_equal([:push, 5], res.pop)
  end

  def test_push2
    res = Typhon::Compiler.compile("aaa@aa@aaa\n")
    assert_equal([:push, 72], res.pop)
  end

  def test_dup
    res = Typhon::Compiler.compile("a a")
    assert_equal([:dup], res.pop)
  end

  def test_copy
    res = Typhon::Compiler.compile("a@aaa@a@\n")
    assert_equal([:copy, 5], res.pop)
  end

  def test_swap
    res = Typhon::Compiler.compile("a @")
    assert_equal([:swap], res.pop)
  end

  def test_discard
    res = Typhon::Compiler.compile("a  ")
    assert_equal([:discard], res.pop)
  end

  def test_slide
    res = Typhon::Compiler.compile("a@ aa@a@\n")
    assert_equal([:slide, 5], res.pop)
  end

  def test_add
    res = Typhon::Compiler.compile("@aaa")
    assert_equal([:add], res.pop)
  end

  def test_sub
    res = Typhon::Compiler.compile("@aa@")
    assert_equal([:sub], res.pop)
  end

  def test_mul
    res = Typhon::Compiler.compile("@aa ")
    assert_equal([:mul], res.pop)
  end

  def test_div
    res = Typhon::Compiler.compile("@a@a")
    assert_equal([:div], res.pop)
  end

  def test_mod
    res = Typhon::Compiler.compile("@a@@")
    assert_equal([:mod], res.pop)
  end

  def test_heap_write
    res = Typhon::Compiler.compile("@@ ")
    assert_equal([:heap_write], res.pop)    
  end

  def test_heap_read
    res = Typhon::Compiler.compile("@@@")
    assert_equal([:heap_read], res.pop)
  end

  def test_label
    res = Typhon::Compiler.compile(" aa@a\n")
    assert_equal([:label, "@a"], res.pop)
  end

  def test_call
    res = Typhon::Compiler.compile(" a@@a\n")
    assert_equal([:call, "@a"], res.pop)
  end

  def test_jump
    res = Typhon::Compiler.compile(" a @a\n")
    assert_equal([:jump, "@a"], res.pop)
  end

  def test_jump_zero
    res = Typhon::Compiler.compile(" @a@a\n")
    assert_equal([:jump_zero, "@a"], res.pop)
  end

  def test_jump_negative
    res = Typhon::Compiler.compile(" @@@a\n")
    assert_equal([:jump_negative, "@a"], res.pop)
  end

  def test_return
    res = Typhon::Compiler.compile(" @ ")
    assert_equal([:return], res.pop)
  end

  def test_exit
    res = Typhon::Compiler.compile("   ")
    assert_equal([:exit], res.pop)
  end

  def test_charout
    res = Typhon::Compiler.compile("@ aa")
    assert_equal([:char_out], res.pop)
  end

  def test_num_out
    res = Typhon::Compiler.compile("@ a@")
    assert_equal([:num_out], res.pop)
  end

  def test_char_in
    res = Typhon::Compiler.compile("@ @ ")
    assert_equal([:char_in], res.pop)
  end

  def test_num_in
    res = Typhon::Compiler.compile("@ @@")
    assert_equal([:num_in], res.pop)
  end

  def test_flac
    res = Typhon::Compiler.compile("@ @@@ @ @ a@")
    assert_equal([:num_out], res.pop)
    assert_equal([:char_in], res.pop)
    assert_equal([:num_in], res.pop)
  end

  def test_parseError
    msg = "どの命令にもマッチしませんでした(7)"
    assert_raise_with_message(Typhon::Compiler::ProgramError, msg) do
      Typhon::Compiler.compile("@ @@@@@@")
    end
  end

  def test_numError
    flunk("This test is FAILURE but it's OK")
    msg = "数値は@とaで指定してください(a@aaa)"
    assert_raise_with_message(Typhon::Compiler::ProgramError, msg) do
      Typhon::Compiler.compile("aaa@aa@aaa\n")
    end
  end
end
