#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <libgen.h>
#include <limits.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include <sys/syscall.h>

#include <clandro/clandro_core__nos__c/v1/android/shell/command/environment/AndroidShellEnvironment.h>
#include <clandro/clandro_core__nos__c/v1/data/DataUtils.h>
#include <clandro/clandro_core__nos__c/v1/logger/Logger.h>
#include <clandro/clandro_core__nos__c/v1/clandro/file/ClandroFile.h>
#include <clandro/clandro_core__nos__c/v1/clandro/shell/command/environment/ClandroShellEnvironment.h>
#include <clandro/clandro_core__nos__c/v1/unix/os/selinux/UnixSeLinuxUtils.h>

#include <clandro/clandro_exec__nos__c/v1/ClandroExecLibraryConfig.h>
#include <clandro/clandro_exec__nos__c/v1/clandro/api/clandro_exec/service/ld_preload/ClandroExecLDPreload.h>
#include <clandro/clandro_exec__nos__c/v1/clandro/shell/command/environment/clandro_exec/ClandroExecShellEnvironment.h>

static const char* LOG_TAG = "ld-preload";

static int sSystemLinkerExecEnabled = -1;



int isSystemLinkerExecEnabled() {
     if (sSystemLinkerExecEnabled == 0 || sSystemLinkerExecEnabled == 1) {
        return sSystemLinkerExecEnabled;
    }

    bool isRunningTests = libclandro_exec__nos__c__getIsRunningTests();

    int systemLinkerExecMode = clandroExec_systemLinkerExec_mode_get();
    if (!isRunningTests) {
        logErrorVVerbose(LOG_TAG, "system_linker_exec_mode: '%d'", systemLinkerExecMode);
    }

    int systemLinkerExecEnabled = 1;
    if (systemLinkerExecMode == 0) { // disable
        systemLinkerExecEnabled = 1; // disable

    } else if (systemLinkerExecMode == 2) { // force
        int androidBuildVersionSdk = android_buildVersionSdk_get();
        if (!isRunningTests) {
            logErrorVVerbose(LOG_TAG, "android_build_version_sdk: '%d'", androidBuildVersionSdk);
        }

        bool systemLinkerExecAvailable = false;
        // If running on Android `>= 10`.
        systemLinkerExecAvailable = androidBuildVersionSdk >= 29;
        if (!isRunningTests) {
            logErrorVVerbose(LOG_TAG, "system_linker_exec_available: '%d'", systemLinkerExecAvailable);
        }

        if (systemLinkerExecAvailable) {
            systemLinkerExecEnabled = 0; // enable
        }

    } else { // enable
        if (systemLinkerExecMode != 1) {
            logErrorDebug(LOG_TAG, "Warning: Ignoring invalid system_linker_exec_mode value and using '1' instead");
        }

        bool appDataFileExecExempted = false;

        int androidBuildVersionSdk = android_buildVersionSdk_get();
        if (!isRunningTests) {
            logErrorVVerbose(LOG_TAG, "android_build_version_sdk: '%d'", androidBuildVersionSdk);
        }

        // If running on Android `>= 10`.
        if (androidBuildVersionSdk >= 29) {
            // If running as root or shell user, then the process will
            // be assigned a different process context like
            // `PROCESS_CONTEXT__AOSP_SU`,
            // `PROCESS_CONTEXT__MAGISK_SU` or
            // `PROCESS_CONTEXT__SHELL`, which will not be the same
            // as the one that's exported in
            // `ENV__CLANDRO__SE_PROCESS_CONTEXT`, so we need to check
            // effective uid equals `0` or `2000` instead. Moreover,
            // other su providers may have different contexts, so we
            // cannot just check AOSP or MAGISK contexts.
            // - https://man7.org/linux/man-pages/man2/getuid.2.html
            uid_t uid = geteuid();
            if (uid == 0 || uid == 2000) {
                logErrorVVerbose(LOG_TAG, "uid: '%d'", uid);
                appDataFileExecExempted = true;
            } else {
                char seProcessContext[80];
                bool getSeProcessContextSuccess = false;

                if (getSeProcessContextFromEnv(LOG_TAG, ENV__CLANDRO__SE_PROCESS_CONTEXT,
                        seProcessContext, sizeof(seProcessContext))) {
                    if (!isRunningTests) {
                        logErrorVVerbose(LOG_TAG, "se_process_context_from_env: '%s'", seProcessContext);
                    }
                    getSeProcessContextSuccess = true;
                } else if (getSeProcessContextFromFile(LOG_TAG,
                        seProcessContext, sizeof(seProcessContext))) {
                    if (!isRunningTests) {
                        logErrorVVerbose(LOG_TAG, "se_process_context_from_file: '%s'", seProcessContext);
                    }
                    getSeProcessContextSuccess = true;
                }

                if (getSeProcessContextSuccess) {
                    appDataFileExecExempted = stringStartsWith(seProcessContext, PROCESS_CONTEXT_PREFIX__UNTRUSTED_APP_25) ||
                        stringStartsWith(seProcessContext, PROCESS_CONTEXT_PREFIX__UNTRUSTED_APP_27);
                } else {
                    // If even '/proc/self/attr/current' is not accessible,
                    // then SeLinux may not be supported on the device.
                    logErrorVVerbose(LOG_TAG, "se_process_context_available: '0'");
                    appDataFileExecExempted = true;
                }
            }

            if (!isRunningTests) {
                logErrorVVerbose(LOG_TAG, "app_data_file_exec_exempted: '%d'", appDataFileExecExempted);
            }

            if (!appDataFileExecExempted) {
                systemLinkerExecEnabled = 0; // enable
            }
        }
    }

    sSystemLinkerExecEnabled = systemLinkerExecEnabled;

    if (!isRunningTests) {
        logErrorVVerbose(LOG_TAG, "system_linker_exec_enabled: '%d'",
            sSystemLinkerExecEnabled == 0 ? true : false);
    }

    return sSystemLinkerExecEnabled;
}

int shouldEnableSystemLinkerExecForFile(const char *executablePath) {
    int systemLinkerExecResult = isSystemLinkerExecEnabled();
    // If error or disabled, then just return.
    if (systemLinkerExecResult != 0) {
        return systemLinkerExecResult;
    }

    bool isRunningTests = libclandro_exec__nos__c__getIsRunningTests();

    int isExecutableUnderClandroAppDataDir = clandroApp_dataDir_isPathUnder(LOG_TAG,
        executablePath, NULL, NULL);
    if (isExecutableUnderClandroAppDataDir < 0) {
        return -1;
    }

    if (!isRunningTests) {
        logErrorVVerbose(LOG_TAG, "is_exe_under_clandro_app_data_dir: '%d'",
            isExecutableUnderClandroAppDataDir == 0 ? true : false);
    }

    bool shouldEnableSystemLinkerExec = isExecutableUnderClandroAppDataDir == 0;

    if (!isRunningTests) {
        logErrorVVerbose(LOG_TAG, "system_linker_exec_enabled_for_file: '%d'",
            shouldEnableSystemLinkerExec);
    }

    return shouldEnableSystemLinkerExec ? 0 : 1;
}
