#define _GNU_SOURCE
#include <stddef.h>
#include <errno.h>
#include <fcntl.h>
#include <regex.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include <sys/types.h>
#include <sys/wait.h>

#include <linux/limits.h>

#ifdef __ANDROID__
#include <android/api-level.h>
#endif

#include <clandro/clandro_core__nos__c/v1/ClandroCoreLibraryConfig.h>
#include <clandro/clandro_core__nos__c/v1/data/AssertUtils.h>
#include <clandro/clandro_core__nos__c/v1/data/DataUtils.h>
#include <clandro/clandro_core__nos__c/v1/logger/Logger.h>
#include <clandro/clandro_core__nos__c/v1/clandro/shell/command/environment/ClandroShellEnvironment.h>
#include <clandro/clandro_exec__nos__c/v1/clandro/shell/command/environment/clandro_exec/ClandroExecShellEnvironment.h>
#include <clandro/clandro_core__nos__c/v1/unix/file/UnixFileUtils.h>
#include <clandro/clandro_core__nos__c/v1/unix/os/process/UnixForkUtils.h>
#include <clandro/clandro_core__nos__c/v1/unix/shell/command/environment/UnixShellEnvironment.h>

#include <clandro/clandro_exec__nos__c/v1/ClandroExecLibraryConfig.h>



static const char* LOG_TAG = "rb-tests";

static uid_t UID;

#define CLANDRO_EXEC__TESTS__TESTS_PATH CLANDRO__PREFIX "/libexec/installed-tests/clandro-exec"

extern char **environ;


static void init();
static void initLogger();
static void initChild(ForkInfo *info);
static void runTests();



#include "clandro/api/clandro_exec/service/ld_preload/direct/exec/ExecIntercept_RuntimeBinaryTests.c"



__attribute__((visibility("default")))
int main() {
    init();

    logVVerbose(LOG_TAG, "main()");

    runTests();

    return 0;
}



static void init() {
    errno = 0;

    UID = geteuid();

    libclandro_core__nos__c__setIsRunningTests(true);
    libclandro_exec__nos__c__setIsRunningTests(true);

    initLogger();
}

static void initLogger() {
    setDefaultLogTagAndPrefix("lib" CLANDRO__LNAME "-exec_c");
    setCurrentLogLevel(clandroExec_tests_logLevel_get());
    setLogFormatMode(LOG_FORMAT_MODE__TAG_AND_MESSAGE);
}

static void initChild(ForkInfo *info) {
    (void)info;
    initLogger();
}



void runTests() {

    logDebug(LOG_TAG, "runTests(start)");


    char clandroExec_tests_primaryLDPreloadFilePathBuffer[PATH_MAX];
    int result = getPathFromEnv(LOG_LEVEL__NORMAL, LOG_TAG,
        "primary_ld_preload_file_path", ENV__CLANDRO_EXEC__TESTS__PRIMARY_LD_PRELOAD_FILE_PATH,
        true, 0, true, true,
        clandroExec_tests_primaryLDPreloadFilePathBuffer, sizeof(clandroExec_tests_primaryLDPreloadFilePathBuffer));
    if (result != 0 || strlen(clandroExec_tests_primaryLDPreloadFilePathBuffer) < 1) {
        exit(1);
    }
    const char* clandroExec_tests_primaryLDPreloadFilePath = clandroExec_tests_primaryLDPreloadFilePathBuffer;
    logErrorVVerbose(LOG_TAG, "primary_ld_preload_file_path: '%s'", clandroExec_tests_primaryLDPreloadFilePath);


    ExecIntercept_runTests();


    if (stringEndsWith(clandroExec_tests_primaryLDPreloadFilePath, "/libclandro-exec-linker-ld-preload.so")) {
        logVerbose(LOG_TAG, "LinkerLDPreload_runTests()");
    }


    logDebug(LOG_TAG, "runTests(end)");

}
