#include <stdbool.h>

#include <clandro/clandro_exec__nos__c/v1/ClandroExecLibraryConfig.h>

static bool sIsRunningTests = false;



bool libclandro_exec__nos__c__getIsRunningTests() {
    return sIsRunningTests;
}

void libclandro_exec__nos__c__setIsRunningTests(bool isRunningTests) {
    sIsRunningTests = isRunningTests;
}
