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

#ifndef SATSOLVER_VERSION
#define SATSOLVER_VERSION 0
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
