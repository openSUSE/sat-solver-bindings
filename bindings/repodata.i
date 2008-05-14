/*
 * Repodata
 */

%nodefault _Repodata;
%rename(Repodata) _Repodata;
typedef struct _Repodata {} Repodata;


%extend Repodata {
  /* no constructor, Repodata is embedded in Repo */
  
  /* number of keys in this Repodata */
  int keysize()
  { return $self->nkeys-1; } /* key 0 is reserved */

  /* (File) location of this Repodata, nil if embedded */
  const char *location()
  { return $self->location; }

  /* access Repokey by index */
  XRepokey *key( int i )
  {
    if (i >= 0 && i < $self->nkeys-1)
      return xrepokey_new( $self, i+1 ); /* key 0 is reserved */
    return NULL;
  }
  
#if defined(SWIGRUBY)
  /*
   * Iterate over each key
   */
  void each_key()
  {
    int i;
    for (i = 1; i < $self->nkeys; ++i ) {
      rb_yield( SWIG_NewPointerObj((void*) xrepokey_new( $self, i ), SWIGTYPE_p__Repokey, 0) );
    }
  }
#endif
}

