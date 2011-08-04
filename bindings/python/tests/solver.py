#!/usr/bin/python

import logging
import satsolver
import time

class Solver(object):
	RELATIONS = (
		(">=", satsolver.REL_GE,),
		("<=", satsolver.REL_LE,),
		("=" , satsolver.REL_EQ,),
		("<" , satsolver.REL_LT,),
		(">" , satsolver.REL_GT,),
	)

	def __init__(self, pakfire, arch):
		self.pakfire = pakfire

		# Initialize the pool and set the architecture.
		self.pool = satsolver.Pool()
		self.pool.set_arch(arch)

		#self.pool.add_solv("/home/satsolver/sat-solver-bindings/bindings/testdata/os11-biarch.solv")

		# Initialize all repositories.
		self.repos = self.init_repos()

		self.pool.prepare()

		print self.pool.size()

	def create_relation(self, s):
		s = str(s)

		for pattern, type in self.RELATIONS:
			if not pattern in s:
				continue

			name, version = s.split(pattern, 1)

			return satsolver.Relation(self.pool, name, type, version)

		return satsolver.Relation(self.pool, s)

	def init_repos(self):
		repos = []

		for repo in self.pakfire.repos.enabled:
			solvrepo = self.pool.create_repo(repo.name)
			if repo.name == "installed":
				self.pool.set_installed(solvrepo)

			for pkg in repo.get_all():
				print "%-50s" % pkg.name,

				solvable = satsolver.Solvable(solvrepo, str(pkg.name),
					str(pkg.friendly_version), str(pkg.arch))

				#solvable.attr("solvable:filelist", pkg.filelist)

				for req in pkg.requires:
					rel = self.create_relation(req)
					solvable.requires().add(rel)

				for prov in pkg.provides:
					rel = self.create_relation(prov)
					solvable.provides().add(rel)

				for conf in pkg.conflicts:
					rel = self.create_relation(conf)
					solvable.conflicts().add(rel)

				if pkg.name == "systemd":
					rel = self.create_relation("upstart")
					solvable.conflicts().add(rel)

				for file in pkg.filelist:
					rel = self.create_relation(file)
					solvable.provides().add(rel)

				print "DONE"

			logging.debug("Initialized new repo '%s' with %s packages." % \
				(solvrepo.name(), solvrepo.size()))

			repos.append(solvrepo)

		return repos

	def solve(self):
		print "Starting solver..."
		request = self.pool.create_request()
		for s in sorted(self.pool.providers("upstart"), reverse=True):
			print s, dir(s)
			request.install(s)
			break
		for s in sorted(self.pool.providers("systemd"), reverse=True):
			print s, dir(s)
			request.install(s)
			break

		solver = self.pool.create_solver()
		solver.set_allow_arch_change(True)
		solver.set_allow_vendor_change(True)
		solver.set_allow_uninstall(True)

		start = time.time()
		res = solver.solve(request)

		print "TIME", time.time() - start

		#if not res:
		#	print "Solver had an error."
		#	return

		print res
		#for a in dir(solver):
		#	print a

		print type(solver), sorted(dir(solver))
		print solver.problems_count(), solver.problems_found()

		for p in solver.problems(request):
			print "Problem: %s" % p
			for r in p.ruleinfos():
				print "Ruleinfo: %s" % r.command_s()

				job = r.job()
				if job:
					print "Job: %s" % job

		for s in solver.installs():
			print s

		for s in solver.updates():
			print s

		for s in solver.removes():
			print s


if __name__ == "__main__":
	import base
	pakfire = base.Pakfire()

	s = Solver(pakfire, "i686")

	s.solve()
