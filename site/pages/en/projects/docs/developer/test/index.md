---
page_ref: "@ARK_PROJECT__VARIANT@/clandro/clandro-exec-package/docs/@ARK_DOC__VERSION@/developer/test/index.md"
---

# clandro-exec-package Test Docs

<!-- @ARK_DOCS__HEADER_PLACEHOLDER@ -->

[`clandro-exec-tests`](https://github.com/cl-andro/clandro-exec-package/blob/master/app/main/tests/clandro-exec-tests.in) can be used to run tests for [`clandro-exec`](https://github.com/cl-andro/clandro-exec-package).

Install the updated `clandro-exec` package and then start a new shell so that changes for updated library get loaded.

Update `bash clandro-tools clandro-am` packages to the latest version, otherwise tests will fail. Install Clandro:API app and latest `clandro-api` package to test them as well.

To show help, run `"${CLANDRO__PREFIX:-$PREFIX}/libexec/installed-tests/clandro-exec/app/main/clandro-exec-tests" --help`.

&nbsp;

To run all tests, run `"${CLANDRO__PREFIX:-$PREFIX}/libexec/installed-tests/clandro-exec/app/main/clandro-exec-tests" -vv all`. You can optionally run only `unit` or `runtime` tests as well.
- The `unit` tests test different units/components of libraries and executables.
- The `runtime` tests test the runtime execution of libraries and executables.

&nbsp;

Two variants of each test binary is compiled.
- With `fsanitize` enabled with the `-fsanitize=address -fsanitize-recover=address -fno-omit-frame-pointer` flags that contain `-fsanitize` in filename
- Without `fsanitize` enabled that contain `-nofsanitize` in filename.

This is requires because `fsanitize` does not work on all Android versions/architectures properly and may crash with false positives with the `AddressSantizier: SEGV on unknown address` error, like Android `7` (always crashes) and `x86_64` (requires loop to trigger as occasional crash), even for a source file compiled with an empty `main()` function.

To enable `AddressSantizier` while running `clandro-exec-tests`, pass `-f`. To also enable `LeakSanitizer`, pass `-l` as well, but if it is not supported on current device, the `clandro-exec-tests` will error out with `AddressSantizier: detect_leaks is not supported on this platform`.

If you get `CANNOT LINK EXECUTABLE *: library "libclang_rt.asan-aarch64.so" not found`, like on Android `7`, you will need to install the `libcompiler-rt` package to get the `libclang_rt.asan-aarch64.so` dynamic library required for `AddressSantizier` if passing `-f`. Export library file path with `export LD_LIBRARY_PATH="${CLANDRO__PREFIX:-$PREFIX}/lib/clang/17/lib/linux"` before running tests.

&nbsp;

The `libclandro-exec_nos_c_tre_runtime-binary-tests` is also additionally compiled for Android API level `28` by `clandro-exec` [`build.sh`](https://github.com/cl-andro/clandro-packages/blob/master/packages/clandro-exec/build.sh) if `CLANDRO_PKG_API_LEVEL` is `< 28` to test APIs that are only available on higher Android versions like `fexecve()`. When `libclandro-exec_nos_c_tre_tests` is executed, the `libclandro_exec__nos__c__runtime_binary_tests__run_command()` function dynamically calls the `libclandro-exec_nos_c_tre_runtime-binary-tests` variant that would be supported by the host device.

---

&nbsp;





## Help

```
clandro-exec-tests can be used to run tests for 'clandro-exec'.


Usage:
    clandro-exec-tests [command_options] <command>

Available commands:
    unit                      Run unit tests.
    runtime                   Run runtime on-device tests.
    all                       Run all tests.

Available command_options:
    [ -h | --help ]           Display this help screen.
    [ --version ]             Display version.
    [ -q | --quiet ]          Set log level to 'OFF'.
    [ -v | -vv | -vvv | -vvvvv ]
                              Set log level to 'DEBUG', 'VERBOSE',
                              'VVERBOSE' and 'VVVERBOSE'.
    [ -f ]                    Use fsanitize binaries for AddressSanitizer.
    [ -l ]                    Detect memory leaks with LeakSanitizer.
                              Requires '-f' to be passed.
    [ --ld-preload-dir=<dir> ]
                              The directory containing `$LD_PRELOAD'
                              libraries: 'libclandro-exec*.so'.
    [ --no-clean ]            Do not clean test files on failure.
    [ --test-names-filter=<filter> ]
                              Regex to filter which tests to run by
                              test name.
    [ --tests-path=<path> ]   The path to installed-tests directory.
```

---

&nbsp;
