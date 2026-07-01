#ifndef LIBCLANDRO_EXEC__NOS__C__CLANDRO_EXEC_PROCESS___H
#define LIBCLANDRO_EXEC__NOS__C__CLANDRO_EXEC_PROCESS___H

#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif



int clandroExec_process_initProcess(const char *versionToLog, const char *logFilePath);
int clandroExec_process_initLogger(const char *versionToLog, const char *logFilePath);
void clandroExec_process_setIgnoreExit(bool state);
int clandroExec_process_exitProcess();



#ifdef __cplusplus
}
#endif

#endif // LIBCLANDRO_EXEC__NOS__C__CLANDRO_EXEC_PROCESS___H
