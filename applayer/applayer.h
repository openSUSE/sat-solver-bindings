/*
 * Copyright (c) 2007, Novell Inc.
 *
 * This program is licensed under the BSD license, read LICENSE.BSD
 * for further information
 */

/*
 * Sat solver application layer
 *
 * Helper functions
 *
 */


#ifndef SATSOLVER_APPLAYER_H
#define SATSOLVER_APPLAYER_H

#include <pool.h>

/* Fall back to version of libsatsolver-devel */
#ifndef SATSOLVER_VERSION
#ifdef SATSOLVER_PACKAGE_MAJOR
#define SATSOLVER_VERSION_STRING #SATSOLVER_PACKAGE_MAJOR "." #SATSOLVER_PACKAGE_MINOR "." #SATSOLVER_PACKAGE_PATCH
#define SATSOLVER_VERSION_MAJOR SATSOLVER_PACKAGE_MAJOR
#define SATSOLVER_VERSION_MINOR SATSOLVER_PACKAGE_MINOR 
#define SATSOLVER_VERSION_PATCH SATSOLVER_PACKAGE_PATCH
#define SATSOLVER_VERSION (SATSOLVER_VERSION_MAJOR * 10000 + SATSOLVER_VERSION_MINOR * 100 + SATSOLVER_VERSION_PATCH)
#else
#define SATSOLVER_VERSION 0
#endif
#endif

/************************************************
 * string handling
 *
 */

char *to_string(const char *format, ...);
void app_debugstart(Pool *p, int type);
char *app_debugend();

/************************************************
 * Id
 *
 */

const char *my_id2str( const Pool *pool, Id id );

/************************************************
 * Pool
 *
 */

unsigned int pool_xsolvables_count( const Pool *pool );

#endif  /* SATSOLVER_APPLAYER_H */
