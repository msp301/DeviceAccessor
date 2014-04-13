#ifndef XSHELPER_H
#define XSHELPER_H

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

SV * get_hash_value( HV *hash, char *key );

#endif
