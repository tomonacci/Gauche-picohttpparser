/*
 * picohttpparser.c
 */

#include "picohttpparser.h"

/*
 * The following function is a dummy one; replace it for
 * your C function definitions.
 */

ScmObj test_picohttpparser(void)
{
    return SCM_MAKE_STR("picohttpparser is working");
}

/*
 * Module initialization function.
 */
extern void Scm_Init_picohttpparserlib(ScmModule*);

void Scm_Init_picohttpparser(void)
{
    ScmModule *mod;

    /* Register this DSO to Gauche */
    SCM_INIT_EXTENSION(picohttpparser);

    /* Create the module if it doesn't exist yet. */
    mod = SCM_MODULE(SCM_FIND_MODULE("picohttpparser", TRUE));

    /* Register stub-generated procedures */
    Scm_Init_picohttpparserlib(mod);
}
