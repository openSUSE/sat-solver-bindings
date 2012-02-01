require File.expand_path(File.join(File.dirname(__FILE__), 'helper'))
#
# Check fileprovides (bnc#744383)
#

class FileProvidesTest < Test::Unit::TestCase
  def test_file_provides
    pool = Satsolver::Pool.new
    pool.arch = "x86_64"
    solvpath = Pathname( File.dirname( __FILE__ ) ) + Pathname( "../../testdata" ) + "oss114.solv"
    repo = pool.add_solv( solvpath )
    repo.name = "Demo"
    puts "Repo #{repo.name} loaded with #{repo.size} solvables"
    
    pool.prepare

    file = "/usr/sbin/fonts-config"
    puts "Providers of '#{file}':"
    count = 0
    pool.each_provider( file ) do |s|
      puts "  #{s} [#{s.repo.name}]"
      count += 1
    end
#    assert count > 0

    rel = pool.create_relation(file)

    puts "Providers of '#{rel}':"
    count = 0
    pool.each_provider(rel) do |s|
      puts "  #{s} [#{s.repo.name}]"
      count += 1
    end
#    assert count > 0
  end
  
  #
  # Test case for bnc#744383
  #
  def test_file_requires
    pool = Satsolver::Pool.new
    pool.arch = "x86_64"
    solvpath = Pathname( File.dirname( __FILE__ ) ) + Pathname( "../../testdata" ) + "oss114.solv"
    repo = pool.add_solv solvpath
    repo.name = "oss-11.4"
    puts "Repo #{repo.name} loaded with #{repo.size} solvables"
    solvpath = Pathname( File.dirname( __FILE__ ) ) + Pathname( "../../testdata" ) + "update114.solv"
    repo = pool.add_solv solvpath
    repo.name = "update-11.4"
    puts "Repo #{repo.name} loaded with #{repo.size} solvables"
#    solvpath = Pathname( File.dirname( __FILE__ ) ) + Pathname( "../../testdata" ) + "merged114.solv" 
#    repo = pool.add_solv solvpath
#    repo.name = "os11-beta5-x86_64"
    
    pool.prepare

    solvable = pool.find "fetchmsttfonts"
    assert solvable
    request = Satsolver::Request.new pool
    request.install solvable
    solver = pool.create_solver
    solver.solve request
    if solver.problems?
      STDERR.puts "** Problems"
      assert false
      if false #debug
        i = 0
        solver.each_problem( request ) do |p|
          i += 1
          j = 0
          p.each_ruleinfo do |ri|
            j += 1
            puts "#{i}.#{j}: cmd: #{ri.command_s}\n\tRuleinfo: #{ri}"
            job = ri.job
            puts "\tJob #{job}" if job
          end
        end
      end
    else
      STDERR.puts "** #{solver.decision_count} decisions"
      assert true
      if false # debug
        i = 0
        solver.each_decision do |d|
          i += 1
          case d.op
          when Satsolver::DECISION_INSTALL
            puts "#{i}: Install #{d.solvable}\n\t#{d.ruleinfo.command_s}: #{d.ruleinfo}"
          when Satsolver::DECISION_REMOVE
            puts "#{i}: Remove #{d.solvable}\n\t#{d.ruleinfo.command_s}: #{d.ruleinfo}"
          when Satsolver::DECISION_OBSOLETE
            puts "#{i}: Obsoleted #{d.solvable}\n\t#{d.ruleinfo.command_s}: #{d.ruleinfo}"
          when Satsolver::DECISION_UPDATE
            puts "#{i}: Update to #{d.solvable}\n\t#{d.ruleinfo.command_s}: #{d.ruleinfo}"
          else
            puts "#{i}: Decision op #{d.op}"
          end
        end
      end
    end
  end
end
