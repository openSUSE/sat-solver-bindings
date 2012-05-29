/*
 Document-module: Satsolver
 =About Satsolver

 Satsolver is the module namespace for sat-solver bindings.

 sat-solver provides a repository data cache and a dependency solver
 for rpm-style dependencies based on a Satisfyability engine.

 See http://en.opensuse.org/Package_Management/Sat_Solver for details
 about the internals of sat-solver.

 Solving needs a Request containing a set of Jobs. Jobs install,
 update, remove, or lock Solvables (packages), names (a Solvable
 providing name), or Relations (+name+ +op+ +version.release+).

 Successful solving creates a Transaction, listing the Solvables to
 install, update, or remove in order to fulfill the Request while
 keeping the installed system consistent.

 Solver errors are reported as Problems. Each Problem has a
 description of what went wrong and a set of Solutions how to
 remediate the Problem.

 ==Working with sat-solver bindings
 
 The sat-solver bindings provide two main functionalities
 - An efficient cache of repository data
 - An ultra-fast dependency solver working on the cached data
 
 The core of the repository cache is represented by the _Pool_. It
 represents the context the solver works in. The Pool holds
 _Solvables_, representing (RPM-based) packages.
 
 Solvables have a
 name, a version and an architecture. Solvables usually have
 _Dependencies_, organized as sets of _Relation_s Solvables can also
 hold additional attribute data, typically everything from the RPM
 header, i.e. _vendor_, _download_ _size_, _install_ _size_, etc.

 Solvables within the Pool are grouped in Repositories. Filling the
 Pool by loading a .+solv+ file, representing a _Repository_, is the
 preferred way.
 
 In a nutshell:
 Pool _has_ _lots_ _of_ Repositories _have_ _lots_ _of_ Solvables
 _have_ _lots_ _of_ Attributes.
 
*/


%module satsolver
%feature("autodoc","1");

#if defined(SWIGRUBY)
%include <ruby.swg>
#endif

#define __type

%{

#include "satsolver-bindings.h"
#include "generic_helpers.h"
#if HAVE_SATVERSION_H
#include <satversion.h>
#endif

/*
 * type definitions to keep the C code generic
 */
 
#if defined(SWIGPYTHON)
#define Target_Null_p(x) (x == Py_None)
#define Target_INCREF(x) Py_INCREF(x)
#define Target_DECREF(x) Py_DECREF(x)
#define Target_True Py_True
#define Target_False Py_False
#define Target_Null Py_None
#define Target_Type PyObject*
#define Target_Bool(x) PyBool_FromLong(x)
#define Target_Char16(x) PyInt_FromLong(x)
#define Target_Int(x) PyInt_FromLong(x)
#define Target_String(x) PyString_FromString(x)
#define Target_Real(x) Py_None
#define Target_Array() PyList_New(0)
#define Target_SizedArray(len) PyList_New(len)
#define Target_ListSet(x,n,y) PyList_SetItem(x,n,y)
#define Target_Append(x,y) PyList_Append(x,y)
#define Target_DateTime(x) Py_None
#include <Python.h>
#define TARGET_THREAD_BEGIN_BLOCK SWIG_PYTHON_THREAD_BEGIN_BLOCK
#define TARGET_THREAD_END_BLOCK SWIG_PYTHON_THREAD_END_BLOCK
#define TARGET_THREAD_BEGIN_ALLOW SWIG_PYTHON_THREAD_BEGIN_ALLOW
#define TARGET_THREAD_END_ALLOW SWIG_PYTHON_THREAD_END_ALLOW
#endif

#if defined(SWIGRUBY)
#define Target_Null_p(x) NIL_P(x)
#define Target_INCREF(x) 
#define Target_DECREF(x) 
#define Target_True Qtrue
#define Target_False Qfalse
#define Target_Null Qnil
#define Target_Type VALUE
#define Target_Bool(x) ((x)?Qtrue:Qfalse)
#define Target_Char16(x) INT2FIX(x)
#define Target_Int(x) INT2FIX(x)
#define Target_String(x) rb_str_new2(x)
#define Target_Real(x) rb_float_new(x)
#define Target_Array() rb_ary_new()
#define Target_SizedArray(len) rb_ary_new2(len)
#define Target_ListSet(x,n,y) rb_ary_store(x,n,y)
#define Target_Append(x,y) rb_ary_push(x,y)
#define Target_DateTime(x) datetime_value(x)
#define TARGET_THREAD_BEGIN_BLOCK do {} while(0)
#define TARGET_THREAD_END_BLOCK do {} while(0)
#define TARGET_THREAD_BEGIN_ALLOW do {} while(0)
#define TARGET_THREAD_END_ALLOW do {} while(0)
#include <ruby.h>
#include <ruby.h>
#if HAVE_RUBY_IO_H
#include <ruby/io.h> /* Ruby 1.9 style */
#else
#include <rubyio.h>
#endif
#endif

#if defined(SWIGPERL)
#define TARGET_THREAD_BEGIN_BLOCK do {} while(0)
#define TARGET_THREAD_END_BLOCK do {} while(0)
#define TARGET_THREAD_BEGIN_ALLOW do {} while(0)
#define TARGET_THREAD_END_ALLOW do {} while(0)

SWIGINTERNINLINE SV *SWIG_From_long  SWIG_PERL_DECL_ARGS_1(long value);
SWIGINTERNINLINE SV *SWIG_FromCharPtr(const char *cptr);
SWIGINTERNINLINE SV *SWIG_From_double  SWIG_PERL_DECL_ARGS_1(double value);

#define Target_Null_p(x) (x == NULL)
#define Target_INCREF(x) 
#define Target_DECREF(x) 
#define Target_True (&PL_sv_yes)
#define Target_False (&PL_sv_no)
#define Target_Null NULL
#define Target_Type SV *
#define Target_Bool(x) (x)?Target_True:Target_False
#define Target_Char16(x) SWIG_From_long(x)
#define Target_Int(x) SWIG_From_long(x)
#define Target_String(x) SWIG_FromCharPtr(x)
#define Target_Real(x) SWIG_From_double(x)
#define Target_Array() (SV *)newAV()
#define Target_SizedArray(len) (SV *)newAV()
#define Target_ListSet(x,n,y) av_store((AV *)(x),n,y)
#define Target_Append(x,y) av_push(((AV *)(x)), y)
#define Target_DateTime(x) NULL
#include <perl.h>
#include <EXTERN.h>
#endif

/*
 * target_charptr
 * Convert target type to const char *
 */

static const char *
target_charptr(Target_Type target)
{
  const char *str;
#if defined (SWIGRUBY)
  if (SYMBOL_P(target)) {
    str = rb_id2name(SYM2ID(target));
  }
  else if (TYPE(target) == T_STRING) {
    str = StringValuePtr(target);
  }
  else if (target == Target_Null) {
    str = NULL;
  }
  else {
    VALUE target_s = rb_funcall(target, rb_intern("to_s"), 0 );
    str = StringValuePtr(target_s);
  }
#elif defined (SWIGPYTHON)
  str = PyString_AsString(target);
#else
#warning target_charptr not defined
  str = NULL;
#endif
  return str;
}



%}

/*=============================================================*/
/* BINDING CODE                                                */
/*=============================================================*/

%constant int BINDINGS_VERSION = (SATSOLVER_BINDINGS_MAJOR * 10000 + SATSOLVER_BINDINGS_MINOR * 100 + SATSOLVER_BINDINGS_PATCH);
%constant int LIBRARY_VERSION = SATSOLVER_VERSION;

%include exception.i

%include "generic_helpers.i"

/*
 * just define empty structs to expose the types to SWIG
 */

%include "pool.i"
%include "repo.i"
%include "repodata.i"
%include "repokey.i"
%include "relation.i"
%include "dependency.i"
%include "solvable.i"
%include "job.i"
%include "request.i"
%include "decision.i"
%include "problem.i"
%include "solution.i"
%include "covenant.i"
%include "ruleinfo.i"
%include "solver.i"
%include "dataiterator.i"
%include "step.i"
%include "transaction.i"
