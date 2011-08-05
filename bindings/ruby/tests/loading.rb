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
  end
end
