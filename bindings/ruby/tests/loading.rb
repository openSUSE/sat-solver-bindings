require File.expand_path(File.join(File.dirname(__FILE__), 'helper'))
#
# Test loading of the bindings
#

# test loading of extension
require 'test/unit'

class LoadTest < Test::Unit::TestCase
  def test_loading
    require 'satsolver'
    assert true
    bv = Satsolver::BINDINGS_VERSION
    assert bv
    assert bv.is_a? Integer
    lv = Satsolver::LIBRARY_VERSION
    assert lv
    assert lv.is_a? Integer
    puts "Library #{lv}, Bindings #{bv}"
  end
end
