# ==================================================
# Versioning
# ==========
#
# MAJOR Major number for this branch.
#
# MINOR The most recent interface number this
#     library implements.
#
# COMPATMINOR The latest binary compatible minor number
#     this library implements.
#
# PATCH The implementation number of the current interface.
#
#
# - The package VERSION will be MAJOR.MINOR.PATCH.
#
# - Libtool's -version-info will be derived from MAJOR, MINOR, PATCH
#   and COMPATMINOR (see configure.ac).
#
# - Changing MAJOR always breaks binary compatibility.
#
# - Changing MINOR doesn't break binary compatibility by default.
#   Only if COMPATMINOR is changed as well.
#
#
# 1) After branching from TRUNK increment TRUNKs MAJOR and
#    start with version `MAJOR.0.0' and also set COMPATMINOR to 0.
#
# 2) Update the version information only immediately before a public release
#    of your software. More frequent updates are unnecessary, and only guarantee
#    that the current interface number gets larger faster.
#
# 3) If the library source code has changed at all since the last update,
#    then increment PATCH.
#
# 4) If any interfaces have been added, removed, or changed since the last
#    update, increment MINOR, and set PATCH to 0.
#
# 5) If any interfaces have been added since the last public release, then
#    leave COMPATMINOR unchanged. (binary compatible change)
#
# 6) If any interfaces have been removed since the last public release, then
#    set COMPATMINOR to MINOR. (binary incompatible change)
#

SET(SATSOLVER_BINDINGS_MAJOR "0")
SET(SATSOLVER_BINDINGS_MINOR "45")
SET(SATSOLVER_BINDINGS_PATCH "0")

# last released 0.45.0

# libsatsolver releases
# SLES-11       : 0.13.x (0.13.4 - GA, 0.14.17 - SP1-GA)
# openSUSE 11.2 : 0.14.x
# MeeGo 1.0     : 0.14.16
# SLES-11-SP1   : 0.14.17
# MeeGo 1.1     : 0.15.0
# openSUSE 11.3 : 0.15.x
# openSUSE 11.4 : 0.16.x
# openSUSE 12.1 : 0.17.x
# openSUSE 12.2 : 0.17.x (?)
