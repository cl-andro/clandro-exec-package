#ifndef LIBCLANDRO_EXEC__NOS__C__CLANDRO_EXEC_LIBRARY_CONFIG___H
#define LIBCLANDRO_EXEC__NOS__C__CLANDRO_EXEC_LIBRARY_CONFIG___H

#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif



/** Get `sIsRunningTests`. */
bool libclandro_exec__nos__c__getIsRunningTests();

/** Set `sIsRunningTests`. */
void libclandro_exec__nos__c__setIsRunningTests(bool isRunningTests);



#ifdef __cplusplus
}
#endif

#endif // LIBCLANDRO_EXEC__NOS__C__CLANDRO_EXEC_LIBRARY_CONFIG___H
