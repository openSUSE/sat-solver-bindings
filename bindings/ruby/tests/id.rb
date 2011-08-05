require File.expand_path(File.join(File.dirname(__FILE__), 'helper'))
#
# Test internal Id handling
#

require 'test/unit'
require 'satsolver'

class IdTest < Test::Unit::TestCase
  def test_id
    pool = Satsolver::Pool.new
    assert pool
    # no create
    id = pool.id("abc")
    assert_equal 0, id
    s = pool.string(id)
    assert s.nil?
    # create
    id = pool.id("abc",1)
    assert_not_equal 0, id
    s = pool.string(id)
    assert_equal "abc", s
  end
end
