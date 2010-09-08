require 'test/unit'
require 'lib/typhon/vm'

class TC_VM < Test::Unit::TestCase

  class Display
    attr_accessor :print

    def initialize
      @print = []
    end

    def write(msg)
      @print.push(msg)
    end
  end

  def test_push
    res = display_capture do
      Typhon::VM.run([[:push, 1], [:push, 2], [:num_out], [:num_out], [:exit]])
    end
    assert_equal([2, 1], res)
  end

  def test_dup
    res = display_capture do
      Typhon::VM.run([[:push, 1], [:dup], [:num_out], [:num_out], [:exit]])
    end
    assert_equal([1, 1], res)
  end

  def test_swap
    res = display_capture do
      Typhon::VM.run([[:push, 1], [:push, 2], [:swap], [:num_out], [:num_out], [:exit]])
    end
    assert_equal([1, 2], res)
  end

  def test_discard
    res = display_capture do
      Typhon::VM.run([[:push, 1], [:discard], [:push, 2], [:num_out], [:exit]])
    end
    assert_equal([2], res)
  end

  def test_slide
    res = display_capture do
      Typhon::VM.run([[:push, 1], [:push, 2], [:push, 3], [:push, 4], [:slide, 2], [:num_out], [:num_out], [:exit]])
    end
    assert_equal([4, 1], res)
  end

  def test_add
    res = display_capture do
      Typhon::VM.run([[:push, 1], [:push, 2], [:add], [:num_out], [:exit]])
    end
    assert_equal([3], res)
  end

  def test_sub
    res = display_capture do
      Typhon::VM.run([[:push, 5], [:push, 2], [:sub], [:num_out], [:exit]])
    end
    assert_equal([3], res)
  end

  def test_mul
    res = display_capture do
      Typhon::VM.run([[:push, 5], [:push, 2], [:mul], [:num_out], [:exit]])
    end
    assert_equal([10], res)
  end

  def test_div
    res = display_capture do
      Typhon::VM.run([[:push, 10], [:push, 2], [:div], [:num_out], [:exit]])
    end
    assert_equal([5], res)
  end

  def test_mod
    res = display_capture do
      Typhon::VM.run([[:push, 10], [:push, 3], [:mod], [:num_out], [:exit]])
    end
    assert_equal([1], res)
  end

  def test_heap
    res = display_capture do
      Typhon::VM.run([[:push, 3], [:push, 10], [:heap_write], [:push, 3], [:heap_read], [:num_out], [:exit]])
    end
    assert_equal([10], res)
  end

  def test_jump
    res = display_capture do
      Typhon::VM.run([[:push, 3], [:push, 10], [:jump, "@@@"], [:add], [:label, "@@@"], [:num_out], [:num_out], [:exit]])
    end
    assert_equal([10, 3], res)
  end

  def test_jump_zero
    res = display_capture do
      Typhon::VM.run([[:push, 3], [:push, 10], [:jump_zero, "@@@"], [:push, 8], [:label, "@@@"], [:num_out], [:num_out], [:exit]])
    end
    assert_equal([8, 3], res)
  end

  def test_jump_zero2
    res = display_capture do
      Typhon::VM.run([[:push, 3], [:push, 10], [:push, 0], [:jump_zero, "@@@"], [:add], [:label, "@@@"], [:num_out], [:num_out], [:exit]])
    end
    assert_equal([10, 3], res)
  end

  def test_jump_negative
    res = display_capture do
      Typhon::VM.run([[:push, 3], [:push, 10], [:push, -1], [:jump_negative, "@@@"], [:add], [:label, "@@@"], [:num_out], [:num_out], [:exit]])
    end
    assert_equal([10, 3], res)
  end

  def test_jump_negative2
    res = display_capture do
      Typhon::VM.run([[:push, 3], [:push, 10], [:jump_negative, "@@@"], [:dup], [:label, "@@@"], [:num_out], [:num_out], [:exit]])
    end
    assert_equal([3, 3], res)
  end

  def test_subroutine
    res = display_capture do
      Typhon::VM.run([[:push, 3], [:push, 10], [:call, "@@@"], [:num_out], [:num_out], [:exit], [:label, "@@@"], [:add], [:dup], [:return]])
    end
    assert_equal([13, 13], res)
  end

  def test_out
    res = display_capture do
      Typhon::VM.run([[:push, 100], [:push, 10], [:num_out], [:char_out], [:exit]])
    end
    assert_equal([10, "d"], res)
  end

  def test_char_in
    puts "input 'd5'"
    res = display_capture do
      Typhon::VM.run([[:push, 1], [:char_in], [:push, 1], [:heap_read], [:char_out], [:exit]])
    end
    assert_equal(["d"], res)
  end

  def test_num_in
    res = display_capture do
      Typhon::VM.run([[:push, 1], [:num_in], [:push, 1], [:heap_read], [:num_out], [:exit]])
    end
    assert_equal([5], res)
  end

  def test_error_heap_read
    msg = "ヒープの未初期化の位置を読みだそうとしました。(address = 1)"
    assert_raise_with_message(Typhon::VM::ProgramError, msg) do
      Typhon::VM.run([[:push, 1], [:heap_read], [:exit]])
    end
  end

  def test_error_exit
    msg = "プログラムの最後はexit命令を実行してください"
    assert_raise_with_message(Typhon::VM::ProgramError, msg) do
      Typhon::VM.run([[:push, 1], [:dup]])
    end
  end

  def test_error_push
    item = "hoge"
    msg = "整数以外(#{item})をプッシュしようとしました"
    assert_raise_with_message(Typhon::VM::ProgramError, msg) do
      Typhon::VM.run([[:push, item]])
    end
  end

  def test_error_pop
    msg = "空のスタックをポップしようとしました"
    assert_raise_with_message(Typhon::VM::ProgramError, msg) do
      Typhon::VM.run([[:num_out]])
    end
  end

  def test_error_jump
    name ="@@@"
    msg = "ジャンプ先(#{name.inspect})が見つかりません。"
    assert_raise_with_message(Typhon::VM::ProgramError, msg) do
      Typhon::VM.run([[:jump, name]])
    end
  end

  def test_error_return
    msg = "サブルーチンの外からreturnしようとしました"
    assert_raise_with_message(Typhon::VM::ProgramError, msg) do
      Typhon::VM.run([[:return]])
    end
  end

  private
  def display_capture
    disp = TC_VM::Display.new
    $stdout = disp    
    yield
    $stdout = STDOUT
    return disp.print
  end

  def assert_raise_with_message(e, msg)
    begin
      yield
      flunk("Expected raise " + e.to_s + " but not occurs anthing else.")
    rescue e => ex
      assert_equal(ex.message, msg)
    end
  end
end
