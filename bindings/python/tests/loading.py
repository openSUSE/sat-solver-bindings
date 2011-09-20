import unittest

import os 
cwd = os.path.abspath(os.path.dirname(__file__)) 
import sys
sys.path.insert(0, cwd + '/../../../build/bindings/python')

class TestSequenceFunctions(unittest.TestCase):
    
  def testloading(self):
    import satsolver


if __name__ == '__main__':
  unittest.main()
