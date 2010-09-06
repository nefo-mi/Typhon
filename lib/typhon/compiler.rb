# coding: utf-8
require 'strscan'

module Typhon
  class Compiler
    class ProgramError < StandardError; end
    NUM = /([a@]+)\n/
    LABEL = NUM

    def self.compile(src)
      new(src).compile
    end
    
    def initialize(src)
      @src = src
      @s = nil
    end

    def compile
      @s = StringScanner.new(bleach(@src))
      insns = []
      until @s.eos?
        insns.push(step)
      end
      insns
    end

    private
    def bleach(src)
      src.gsub(/[^ a@\n]/, "")
    end

    def step
      case
      when @s.scan(/aa#{NUM}/)        then [:push, num(@s[1])]
      when @s.scan(/a a/)             then [:dup]
      when @s.scan(/a@a#{NUM}/)       then [:copy, num(@s[1])]
      when @s.scan(/a @/)             then [:swap]
      when @s.scan(/a  /)             then [:discard]
      when @s.scan(/a@ #{NUM}/)       then [:slide, num(@s[1])]
      when @s.scan(/@aaa/)            then [:add]
      when @s.scan(/@aa@/)            then [:sub]
      when @s.scan(/@aa /)            then [:mul]
      when @s.scan(/@a@a/)            then [:div]
      when @s.scan(/@a@@/)            then [:mod]
      when @s.scan(/@@ /)             then [:heap_write]
      when @s.scan(/@@@/)             then [:heap_read]
      when @s.scan(/ aa#{LABEL}/)     then [:label, label(@s[1])]
      when @s.scan(/ a@#{LABEL}/)     then [:call, label(@s[1])]
      when @s.scan(/ a #{LABEL}/)     then [:jump, label{@s[1]}]
      when @s.scan(/ @a#{LABEL}/)     then [:jump_zero, label(@s[1])]
      when @s.scan(/ @@#{LABEL}/)     then [:jump_negative, label(@s[1])]
      when @s.scan(/ @ /)             then [:return]
      when @s.scan(/   /)             then [:exit]
      when @s.scan(/@ aa/)            then [:char_out]
      when @s.scan(/@ a@/)            then [:num_out]
      when @s.scan(/@ @ /)            then [:char_in]
      when @s.scan(/@ @@/)            then [:num_in]
      else
        raise ProgramError, "どの命令にもマッチしませんでした(#{@s.pos})"
      end        
    end

    def num(str)
      if str !~ /\A[a@]+\z/
        raise ArgumentError, "数値はスペースとタブで指定してください(#{str.inspect})"
      end
      num = str.sub(/\Aa/, "+").sub(/\A@/, "-").gsub(/a/, "0").gsub(/@/, "1")
      num.to_i(2)
    end

    def label(str)
      str
    end

  end
end
