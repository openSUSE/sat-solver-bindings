#
# Check problems
#
#
# In case the Solver cannot find a solution (Solver.problems? true),
# it reports Problems through Solver.each_problem.
#
# A problem is always related to a solver rule.
#
# Linked to each problem is a set of solutions, accessible
# through Problem.each_solution
#
# A solution is a set of elements, each suggesting changes to the initial request.
#

import unittest

import sys
import os

sys.path.insert(0, os.path.abspath(__file__ +'/../../../../build/bindings/python'))

import satsolver


class TestSequenceFunctions(unittest.TestCase):
    

  def setUp(self):
    self.pool = satsolver.Pool()
    assert self.pool
    self.pool.set_arch("i686")
    self.pool.add_solv( os.path.abspath(__file__+"/../../../testdata/os11-biarch.solv" ))
    assert self.pool.size() > 0
    
    
    self.installed = self.pool.create_repo( 'system' )
    assert self.installed
    self.installed.create_solvable( 'A', '0.0-0' )
    self.installed.create_solvable( 'B', '1.0-0' )
    self.installed.create_solvable( 'C', '2.0-0' )
    self.installed.create_solvable( 'D', '3.0-0' )
    
    self.repo = self.pool.create_repo( 'test' )
    assert self.repo
    self.repo.create_solvable( 'A', '1.0-0' )
    self.repo.create_solvable( 'B', '2.0-0' )
    self.repo.create_solvable( 'CC', '3.3-0' )
    self.repo.create_solvable( 'DD', '4.4-0' )


  def solve_and_check(self, pool, installed, request):
    self.pool.set_installed(self.installed)
    solver = self.pool.create_solver()
    solver.set_allow_uninstall(True)
    res = solver.solve( request )
    assert res.__class__.__name__ == 'bool', res.__class__.__name__
    if res == True:
        print "\nSolved ok\n"
        t = solver.transaction()
        t.order()
        print "Transaction with %d steps" % t.size()
        for s in t.steps():
            print "Step %s %s" % (s.type_s(), s.solvable())
        return res
    # solver not successful, show problems
    i = 0
    for p in solver.problems(request):
      i = i + 1
      j = 0
      for ri in p.ruleinfos():
        j = j + 1
        print "%d.%d: cmd: %s, Ruleinfo %s" % (i, j, ri.command_s(), ri)
        job = ri.job()
        if job:
          print "\tJob %s" % job
    print "-----\n"
    return True


  def test_not_installable(self):
    request = self.pool.create_request()
    solv = self.pool.find( "A", self.repo )
    solv.requires().add(self.pool.create_relation( "ZZ" ))
    request.install( solv )
    assert self.solve_and_check( self.pool, self.installed, request )

  def test_nothing_provides(self):
    request = self.pool.create_request()
    solvA = self.pool.find( "A", self.repo )
    solvA.requires().add(self.pool.create_relation( "B", satsolver.REL_GE, "2.0-0" ))
    solvB = self.pool.find( "B", self.repo )
    solvB.requires().add(self.pool.create_relation( "ZZ" ))
    request.install( solvA )
    assert self.solve_and_check( self.pool, self.installed, request )

  def test_same_name(self):
    request = self.pool.create_request()
    solvA = self.pool.find( "A", self.repo )
    request.install( solvA )
    solvA = self.repo.create_solvable( "A", "2.0-0" )
    request.install( solvA )
    assert self.solve_and_check( self.pool, self.installed, request )

  def test_package_conflict(self):
    request = self.pool.create_request()
    solvA = self.pool.find( "A", self.repo )
    solvB = self.pool.find( "B", self.repo )
    solvA.conflicts().add(self.pool.create_relation( solvB.name(), satsolver.REL_EQ, solvB.evr() ))
    solvB.conflicts().add(self.pool.create_relation( solvA.name(), satsolver.REL_EQ, solvA.evr() ))
    request.install( solvA )
    request.install( solvB )
    assert self.solve_and_check( self.pool, self.installed, request )

  def test_package_obsoletes(self):
    request = self.pool.create_request()
    solvCC = self.pool.find( "CC", self.repo )
    solvCC.obsoletes().add(self.pool.create_relation( "A" ))
    request.install( solvCC )
    assert self.solve_and_check( self.pool, self.installed, request )

  def test_full_install(self):
    request = self.pool.create_request()
    request.install( "gnome-desktop" )
    assert self.solve_and_check( self.pool, self.installed, request )

if __name__ == '__main__':
  unittest.main()
