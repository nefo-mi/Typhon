# coding = utf-8

require 'typhon/compiler'
require 'typhon/vm'

module  Typhon
  def self.run(src)
    insns = Typhon::Compiler.compile(src)
    Typhon::VM.run(insns)
  end
end
