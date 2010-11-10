require 'test/unit'

module TyphonTest
  class Display
    attr_accessor :print

    def initialize
      @print = []
    end

    def write(msg)
      @print.push(msg)
    end
  end

  class Keyboard
    def getc
      c = "d"
      c[0]
    end

    def gets
      5
    end
  end
end

class Test::Unit::TestCase
  def simulate_keyboard
    keyboard = TyphonTest::Keyboard.new
    $stdin = keyboard
    yield
    $stdin = STDIN
    return true
  end

  def display_capture
    disp = TyphonTest::Display.new
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
      assert_equal(msg, ex.message)
    end
  end
end
