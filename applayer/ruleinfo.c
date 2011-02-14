/*
 * Copyright (c) 2007, Novell Inc.
 *
 * This program is licensed under the BSD license, read LICENSE.BSD
 * for further information
 */

/*
 * Ruleinfo
 *
 * Information about a single solver rule.
 *
 */

#include <stdlib.h>
#include <job.h>
#include <solverdebug.h>

#include "applayer.h"
#include "ruleinfo.h"

#if SATSOLVER_VERSION < 1640
extern void solver_printproblemruleinfo(Solver *solv, Id rule);
#endif

Ruleinfo *
ruleinfo_new( Solver *solver, Id rule, Request *request )
{
  Ruleinfo *ri = (Ruleinfo *)calloc( 1, sizeof( Ruleinfo ));
  ri->solver = solver;
  ri->id = rule;
#if SATSOLVER_VERSION > 1300
  ri->cmd = solver_ruleinfo((Solver *)solver, rule, &(ri->source), &(ri->target), &(ri->dep));
#else
  /* thats for openSUSE 11.1 */
  ri->cmd = solver_problemruleinfo(solver, &(request->queue), rule, &(ri->dep), &(ri->source), &(ri->target));
#endif	
  return ri;
}


char *
ruleinfo_string( const Ruleinfo *ri )
{
  app_debugstart(ri->solver->pool,SAT_DEBUG_RESULT);
  solver_printproblemruleinfo(ri->solver, ri->id);
  return app_debugend();
}


void
ruleinfo_free( Ruleinfo *ri )
{
  free( ri );
}


const char *
ruleinfo_command_string(const Ruleinfo *ri)
{
  switch (ri->cmd) 
    {
#define rulecase(r) case r: return #r; break
#if SATSOLVER_VERSION > 1300
      rulecase(SOLVER_RULE_UNKNOWN);
      rulecase(SOLVER_RULE_RPM);
      rulecase(SOLVER_RULE_RPM_NOT_INSTALLABLE);
      rulecase(SOLVER_RULE_RPM_NOTHING_PROVIDES_DEP);
      rulecase(SOLVER_RULE_RPM_PACKAGE_REQUIRES);
      rulecase(SOLVER_RULE_RPM_SELF_CONFLICT);
      rulecase(SOLVER_RULE_RPM_PACKAGE_CONFLICT);
      rulecase(SOLVER_RULE_RPM_SAME_NAME);
      rulecase(SOLVER_RULE_RPM_PACKAGE_OBSOLETES);
      rulecase(SOLVER_RULE_RPM_IMPLICIT_OBSOLETES);
      rulecase(SOLVER_RULE_UPDATE);
      rulecase(SOLVER_RULE_FEATURE);
      rulecase(SOLVER_RULE_JOB);
      rulecase(SOLVER_RULE_JOB_NOTHING_PROVIDES_DEP);
      rulecase(SOLVER_RULE_DISTUPGRADE);
      rulecase(SOLVER_RULE_INFARCH);
      rulecase(SOLVER_RULE_LEARNT);
#else
      rulecase(SOLVER_PROBLEM_UPDATE_RULE);
      rulecase(SOLVER_PROBLEM_JOB_RULE);
      rulecase(SOLVER_PROBLEM_JOB_NOTHING_PROVIDES_DEP);
      rulecase(SOLVER_PROBLEM_NOT_INSTALLABLE);
      rulecase(SOLVER_PROBLEM_NOTHING_PROVIDES_DEP);
      rulecase(SOLVER_PROBLEM_SAME_NAME);
      rulecase(SOLVER_PROBLEM_PACKAGE_CONFLICT);
      rulecase(SOLVER_PROBLEM_PACKAGE_OBSOLETES);
      rulecase(SOLVER_PROBLEM_DEP_PROVIDERS_NOT_INSTALLABLE);
      rulecase(SOLVER_PROBLEM_SELF_CONFLICT);
      rulecase(SOLVER_PROBLEM_RPM_RULE);
#endif				  
#undef rulecase
    default:
      break;
    }
  return "Unknown";
}


int
ruleinfo_command(const Ruleinfo *ri)
{
  return ri->cmd;
}

/*
 * If cmd == SOLVER_RULE_JOB
 * then source -> job id
 *      target -> job cmd
 *      dep    -> job data (depending on job cmd !)
 */

Job *
ruleinfo_job(const Ruleinfo *ri)
{
#if SATSOLVER_VERSION > 1300
  if (ri->cmd != SOLVER_RULE_JOB)
#else
  if (ri->cmd != SOLVER_PROBLEM_JOB_RULE)
#endif
    return NULL;
  return job_new( ri->solver->pool, ri->target, ri->source);
}


XSolvable *
ruleinfo_source(const Ruleinfo *ri)
{
#if SATSOLVER_VERSION > 1300
  if (ri->cmd != SOLVER_RULE_JOB)
#else
  if (ri->cmd != SOLVER_PROBLEM_JOB_RULE)
#endif
    return NULL;
  return ri->source ? xsolvable_new( ri->solver->pool, ri->source ) : NULL;
}


XSolvable *
ruleinfo_target(const Ruleinfo *ri)
{
#if SATSOLVER_VERSION > 1300
  if (ri->cmd != SOLVER_RULE_JOB)
#else
  if (ri->cmd != SOLVER_PROBLEM_JOB_RULE)
#endif
    return NULL;
  return ri->target ? xsolvable_new( ri->solver->pool, ri->target ) : NULL;
}


Relation *
ruleinfo_relation(const Ruleinfo *ri)
{
#if SATSOLVER_VERSION > 1300
  if (ri->cmd != SOLVER_RULE_JOB)
#else
  if (ri->cmd != SOLVER_PROBLEM_JOB_RULE)
#endif
    return NULL;
  return ri->dep ? relation_new( ri->solver->pool, ri->dep ) : NULL;
}
