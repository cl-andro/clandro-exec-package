#define _GNU_SOURCE
#include <errno.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>

#include <clandro/clandro_core__nos__c/v1/logger/Logger.h>
#include <clandro/clandro_core__nos__c/v1/clandro/shell/command/environment/ClandroShellEnvironment.h>
#include <clandro/clandro_core__nos__c/v1/unix/shell/command/environment/UnixShellEnvironment.h>

#include <clandro/clandro_exec__nos__c/v1/clandro/shell/command/environment/clandro_exec/ClandroExecShellEnvironment.h>



int clandroExec_logLevel_get() {
    return getLogLevelFromEnv(ENV__CLANDRO_EXEC__LOG_LEVEL);
}



int clandroExec_execveCall_intercept_get() {
    int def = ENV_DEF_VAL__CLANDRO_EXEC__EXECVE_CALL__INTERCEPT;
    const char* value = getenv(ENV__CLANDRO_EXEC__EXECVE_CALL__INTERCEPT);
    if (value == NULL || strlen(value) < 1) {
        return def;
    } else if (strcmp(value, "disable") == 0) {
        return 0;
    } else if (strcmp(value, "enable") == 0) {
        return 1;
    }
    return def;
}

int clandroExec_systemLinkerExec_mode_get() {
    int def = ENV_DEF_VAL__CLANDRO_EXEC__SYSTEM_LINKER_EXEC__MODE;
    const char* value = getenv(ENV__CLANDRO_EXEC__SYSTEM_LINKER_EXEC__MODE);
    if (value == NULL || strlen(value) < 1) {
        return def;
    } else if (strcmp(value, "disable") == 0) {
        return 0;
    } else if (strcmp(value, "enable") == 0) {
        return 1;
    } else if (strcmp(value, "force") == 0) {
        return 2;
    }
    return def;
}



int clandroExec_tests_logLevel_get() {
    return getLogLevelFromEnv(ENV__CLANDRO_EXEC__TESTS__LOG_LEVEL);
}
