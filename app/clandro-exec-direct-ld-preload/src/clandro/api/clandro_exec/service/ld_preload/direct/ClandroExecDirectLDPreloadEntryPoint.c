#define _GNU_SOURCE
#include <stdarg.h>
#include <stdbool.h>
#include <unistd.h>

#include <clandro/clandro_exec__nos__c/v1/clandro/api/clandro_exec/service/ld_preload/direct/exec/ExecIntercept.h>
#include <clandro/clandro_exec__nos__c/v1/clandro/api/clandro_exec/service/ld_preload/direct/exec/ExecVariantsIntercept.h>
#include <clandro/clandro_exec__nos__c/v1/clandro/os/process/clandro_exec/ClandroExecProcess.h>

/**
 * This file defines functions intercepted by `libclandro-exec-direct-ld-preload.so` using `$LD_PRELOAD`.
 *
 * All exported functions must explicitly enable `default` visibility
 * with `__attribute__((visibility("default")))` as `libclandro-exec-direct-ld-preload.so`
 * is compiled with `-fvisibility=hidden` so that no other internal
 * functions are exported.
 *
 * You can check exported symbols for dynamic linking after building with:
 * `nm --demangle --dynamic --defined-only --extern-only /home/builder/.clandro-build/clandro-exec/src/build/output/usr/lib/libclandro-exec-direct-ld-preload.so`.
 */

#define LIBCLANDRO_EXEC_DIRECT_LD_PRELOAD__VERSION_NAME CLANDRO_EXEC_PKG__VERSION
#define LIBCLANDRO_EXEC_DIRECT_LD_PRELOAD__VERSION_STRING "libclandro-exec-direct-ld-preload version=" LIBCLANDRO_EXEC_DIRECT_LD_PRELOAD__VERSION_NAME " org=" CLANDRO__REPOS_HOST_ORG_NAME " project=clandro-exec-package"



void clandroExec_directLdPreload_initProcess() {
    clandroExec_process_initProcess(LIBCLANDRO_EXEC_DIRECT_LD_PRELOAD__VERSION_STRING, NULL);
}



__attribute__((visibility("default")))
int execl(const char *name, const char *arg, ...) {
    clandroExec_directLdPreload_initProcess();

    va_list ap;
    va_start(ap, arg);
    int result = execlIntercept(true, ExecL, name, arg, ap);
    va_end(ap);
    return result;
}

__attribute__((visibility("default")))
int execlp(const char *name, const char *arg, ...) {
    clandroExec_directLdPreload_initProcess();

    va_list ap;
    va_start(ap, arg);
    int result = execlIntercept(true, ExecLP, name, arg, ap);
    va_end(ap);
    return result;
}

__attribute__((visibility("default")))
int execle(const char *name, const char *arg, ...) {
    clandroExec_directLdPreload_initProcess();

    va_list ap;
    va_start(ap, arg);
    int result = execlIntercept(true, ExecLE, name, arg, ap);
    va_end(ap);
    return result;
}

__attribute__((visibility("default")))
int execv(const char *name, char *const *argv) {
    clandroExec_directLdPreload_initProcess();

    return execvIntercept(true, name, argv);
}

__attribute__((visibility("default")))
int execvp(const char *name, char *const *argv) {
    clandroExec_directLdPreload_initProcess();

    return execvpIntercept(true, name, argv);
}

__attribute__((visibility("default")))
int execvpe(const char *name, char *const *argv, char *const *envp) {
    clandroExec_directLdPreload_initProcess();

    return execvpeIntercept(true, name, argv, envp);
}

__attribute__((visibility("default")))
int fexecve(int fd, char *const *argv, char *const *envp) {
    clandroExec_directLdPreload_initProcess();

    return fexecveIntercept(true, fd, argv, envp);
}

__attribute__((visibility("default")))
int execve(const char *name, char *const argv[], char *const envp[]) {
    clandroExec_directLdPreload_initProcess();

    return execveIntercept(true, name, argv, envp);
}
