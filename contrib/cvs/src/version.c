/*
 * Copyright (c) 1994 david d `zoo' zuhn
 * Copyright (c) 1994 Free Software Foundation, Inc.
 * Copyright (c) 1992, Brian Berliner and Jeff Polk
 * Copyright (c) 1989-1992, Brian Berliner
 * 
 * You may distribute under the terms of the GNU General Public License as
 * specified in the README file that comes with this  CVS source distribution.
 * 
 * version.c - the CVS version number
 */

#include "cvs.h"

char *version_string = "Concurrent Versions System (CVS) 1.11";

#ifdef CLIENT_SUPPORT
#ifdef SERVER_SUPPORT
char *config_string = " (client/server)\n";
#else
char *config_string = " (client)\n";
#endif
#else
#ifdef SERVER_SUPPORT
char *config_string = " (server)\n";
#else
char *config_string = "\n";
#endif
#endif

static const char *const version_usage[] =
{
    "Usage: %s %s\n",
    NULL
};

int
version (argc, argv)
    int argc;
    char **argv;
{
    int err = 0;

    if (argc == -1)
	usage (version_usage);

#ifdef CLIENT_SUPPORT
    if (client_active)
        (void) fputs ("Client: ", stdout);
#endif

    /* Having the year here is a good idea, so people have
       some idea of how long ago their version of CVS was
       released.  */
    (void) fputs (version_string, stdout);
    (void) fputs (config_string, stdout);

#ifdef CLIENT_SUPPORT
    if (client_active)
    {
	(void) fputs ("Server: ", stdout);
	start_server ();
	if (supported_request ("version"))
	    send_to_server ("version\012", 0);
	else
	{
	    send_to_server ("noop\012", 0);
	    fputs ("(unknown)\n", stdout);
	}
	err = get_responses_and_close ();
    }
#endif
    return err;
}
	
