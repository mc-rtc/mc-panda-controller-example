#pragma once

#if defined _WIN32 || defined __CYGWIN__
#  define PandaControllerExample_DLLIMPORT __declspec(dllimport)
#  define PandaControllerExample_DLLEXPORT __declspec(dllexport)
#  define PandaControllerExample_DLLLOCAL
#else
// On Linux, for GCC >= 4, tag symbols using GCC extension.
#  if __GNUC__ >= 4
#    define PandaControllerExample_DLLIMPORT __attribute__((visibility("default")))
#    define PandaControllerExample_DLLEXPORT __attribute__((visibility("default")))
#    define PandaControllerExample_DLLLOCAL __attribute__((visibility("hidden")))
#  else
// Otherwise (GCC < 4 or another compiler is used), export everything.
#    define PandaControllerExample_DLLIMPORT
#    define PandaControllerExample_DLLEXPORT
#    define PandaControllerExample_DLLLOCAL
#  endif // __GNUC__ >= 4
#endif // defined _WIN32 || defined __CYGWIN__

#ifdef PandaControllerExample_STATIC
// If one is using the library statically, get rid of
// extra information.
#  define PandaControllerExample_DLLAPI
#  define PandaControllerExample_LOCAL
#else
// Depending on whether one is building or using the
// library define DLLAPI to import or export.
#  ifdef PandaControllerExample_EXPORTS
#    define PandaControllerExample_DLLAPI PandaControllerExample_DLLEXPORT
#  else
#    define PandaControllerExample_DLLAPI PandaControllerExample_DLLIMPORT
#  endif // PandaControllerExample_EXPORTS
#  define PandaControllerExample_LOCAL PandaControllerExample_DLLLOCAL
#endif // PandaControllerExample_STATIC