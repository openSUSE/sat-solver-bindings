%module satsolverx

%{

extern "C"
{
#include "ruby.h"
#include "rubyio.h"
#include "bitmap.h"
#include "evr.h"
#include "hash.h"
#include "poolarch.h"
#include "pool.h"
#include "poolid.h"
#include "poolid_private.h"
#include "pooltypes.h"
#include "queue.h"
#include "solvable.h"
#include "solver.h"
#include "source.h"
#include "source_solv.h"
}


%}

/*%typemap(ruby, in) FILE* {
  Check_Type($input, T_FILE);
  $1 = RFILE($input)->fptr;

}*/

%typemap(ruby,in) FILE * {
    OpenFile *fptr;

    Check_Type($input, T_FILE);    
    GetOpenFile($input, fptr);
    /*rb_io_check_writable(fptr);*/
    $1 = GetReadFile(fptr);
}

%include "bitmap.h"
%include "evr.h"
%include "hash.h"
%include "poolarch.h"


%alias Pool::nsolvables "size"
%include "pool.h"
%extend _Pool {

  int installable(Solvable *s)
  { return pool_installable($self,s); }

  void prepare()
  { pool_prepare($self);}

  void each_source() 
  {
  }
  
  Source* add_empty_source()
  {
    return pool_addsource_empty($self);
  }
};
%newobject pool_create;
%delobject pool_free;


%include "poolid.h"
%include "poolid_private.h"
%include "pooltypes.h"
%include "queue.h"
%include "solvable.h"
%include "solver.h"
%include "source.h"

%extend Source {

  void each_solvable()
  {
    int i, endof;
    Solvable *s;
    i = $self ? $self->start : 1;
    endof = $self ? $self->start + $self->nsolvables : $self->pool->nsolvables;
    for (; i < endof; i++)
    {
      s = $self->pool->solvables + i;
      rb_yield(SWIG_NewPointerObj((void*) s, $descriptor(storetype), 0));
    }
  }
};

%include "source_solv.h"

%typemap(in) Id {
 $1 = (int) NUM2INT($input);
 printf("Received an integer : %d\n",$1);
}
