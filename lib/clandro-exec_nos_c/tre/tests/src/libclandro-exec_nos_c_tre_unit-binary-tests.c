#define _GNU_SOURCE
#include <assert.h>
#include <elf.h>
#include <errno.h>
#include <fcntl.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include <sys/stat.h>
#include <sys/types.h>

#include <clandro/clandro_core__nos__c/v1/ClandroCoreLibraryConfig.h>
#include <clandro/clandro_core__nos__c/v1/data/AssertUtils.h>
#include <clandro/clandro_core__nos__c/v1/data/DataUtils.h>
#include <clandro/clandro_core__nos__c/v1/logger/Logger.h>
#include <clandro/clandro_core__nos__c/v1/clandro/file/ClandroFile.h>
#include <clandro/clandro_core__nos__c/v1/clandro/shell/command/environment/ClandroShellEnvironment.h>
#include <clandro/clandro_core__nos__c/v1/unix/file/UnixFileUtils.h>
#include <clandro/clandro_core__nos__c/v1/unix/shell/command/environment/UnixShellEnvironment.h>

#include <clandro/clandro_exec__nos__c/v1/ClandroExecLibraryConfig.h>
#include <clandro/clandro_exec__nos__c/v1/clandro/shell/command/environment/clandro_exec/ClandroExecShellEnvironment.h>



static const char* LOG_TAG = "ub-tests";


static void init();
static void initLogger();
static void runTests();



#include "clandro/api/clandro_exec/service/ld_preload/direct/exec/ExecIntercept_UnitBinaryTests.c"



__attribute__((visibility("default")))
int main() {
    init();

    logVVerbose(LOG_TAG, "main()");

    runTests();

    return 0;
}



static void init() {
    errno = 0;

    libclandro_core__nos__c__setIsRunningTests(true);
    libclandro_exec__nos__c__setIsRunningTests(true);

    initLogger();
}

static void initLogger() {
    setDefaultLogTagAndPrefix("lib" CLANDRO__LNAME "-exec_c");
    setCurrentLogLevel(clandroExec_tests_logLevel_get());
    setLogFormatMode(LOG_FORMAT_MODE__TAG_AND_MESSAGE);
}



void runTests() {

    logDebug(LOG_TAG, "runTests(start)");

    ExecIntercept_runTests();

    logDebug(LOG_TAG, "runTests(end)");

}
