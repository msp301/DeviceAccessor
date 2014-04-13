#include "xshelper.h"

SV * get_hash_value( HV *hash, char *key )
{
	SV *key_sv = newSVpv( key, strlen( key ) );
	SV *value_sv;

	if( hv_exists_ent( hash, key_sv, 0 ) )
	{
		HE *entry = hv_fetch_ent( hash, key_sv, 0, 0 );
		value_sv = HeVAL( entry );
	}

	return value_sv;
}

