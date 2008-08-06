#
# Check Filelists
#

import unittest

import sys
sys.path.insert(0, '../../../build/bindings/python')

import satsolver


class TestSequenceFunctions(unittest.TestCase):
    
  def test_filelists(self):
    pool = satsolver.Pool()
    assert pool
    pool.set_arch("x86_64")
    repo = pool.add_solv( "os11-biarch.solv" )
    repo.set_name( "openSUSE 11.0 Beta3 BiArch" )
    i = 0
    for solv in pool:
      print "Filelist for ", solv
      if solv.attr_exists('solvable:filelist'):
#        print solv, " has a filelist"
        print solv.attr('solvable:filelist')
      else:
        print '-'
      i = i + 1
      if i > 2:
          break
if __name__ == '__main__':
  unittest.main()

