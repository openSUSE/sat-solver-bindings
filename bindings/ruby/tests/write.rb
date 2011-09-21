#
# bindings/ruby/test/write.rb
#
# Test Repo#write
#
require File.expand_path(File.join(File.dirname(__FILE__), 'helper'))

class WriteTest < Test::Unit::TestCase
  def test_write
    pool1 = Satsolver::Pool.new
    pool1.arch = "i686"
    # Create two solvables
    repo1 = pool1.create_repo( 'test' )
    solv1 = repo1.create_solvable( 'one', '1.0-0' )
    solv2 = Satsolver::Solvable.new( repo1, 'two', '2.0-0', 'noarch' )
    solv2.vendor = "Ruby"
    
    rel = Satsolver::Relation.new( pool1, "two", Satsolver::REL_GE, "2.0-0" )
    solv1.requires << rel
    
    if Satsolver::LIBRARY_VERSION > 1701 && repo1.respond_to?(:write)
      # write to 'write.solv'
      File.open("write.solv", "w+") do |f|
	repo1.write(f)
      end
    
      # read to separate pool
      pool2 = Satsolver::Pool.new
      pool2.arch = "i686"
      repo2 = pool2.add_solv "write.solv"
      assert_equal pool1.size, pool2.size
      assert_equal repo1.size, repo2.size    
    end
  end
  
end
