export CLANDRO_EXEC_PKG__VERSION := 2.4.0
export CLANDRO_EXEC_PKG__ARCH
export CLANDRO_EXEC_PKG__INSTALL_PREFIX
export CLANDRO_EXEC_PKG__TESTS__API_LEVEL :=

export CLANDRO__NAME := Clandro# Default value: `Clandro`
export CLANDRO__LNAME := clandro# Default value: `clandro`

export CLANDRO__REPOS_HOST_ORG_NAME := clandro# Default value: `clandro`

export CLANDRO_APP__NAME := Clandro# Default value: `Clandro`
export CLANDRO_APP__PACKAGE_NAME := com.clandro# Default value: `com.clandro`
export CLANDRO_APP__DATA_DIR := /data/data/$(CLANDRO_APP__PACKAGE_NAME)# Default value: `/data/data/com.clandro`

export CLANDRO__ROOTFS := $(CLANDRO_APP__DATA_DIR)/files# Default value: `/data/data/com.clandro/files`
export CLANDRO__PREFIX := $(CLANDRO__ROOTFS)/usr# Default value: `/data/data/com.clandro/files/usr`
export CLANDRO__PREFIX__BIN_DIR := $(CLANDRO__PREFIX)/bin# Default value: `/data/data/com.clandro/files/usr/bin`
export CLANDRO__PREFIX__INCLUDE_DIR := $(CLANDRO__PREFIX)/include# Default value: `/data/data/com.clandro/files/usr/include`
export CLANDRO__PREFIX__LIB_DIR := $(CLANDRO__PREFIX)/lib# Default value: `/data/data/com.clandro/files/usr/lib`

export CLANDRO_ENV__S_ROOT := CLANDRO_# Default value: `CLANDRO_`
export CLANDRO_ENV__SS_CLANDRO := _# Default value: `_`
export CLANDRO_ENV__S_CLANDRO := $(CLANDRO_ENV__S_ROOT)$(CLANDRO_ENV__SS_CLANDRO)# Default value: `CLANDRO__`
export CLANDRO_ENV__SS_CLANDRO_APP := APP__# Default value: `APP__`
export CLANDRO_ENV__S_CLANDRO_APP := $(CLANDRO_ENV__S_ROOT)$(CLANDRO_ENV__SS_CLANDRO_APP)# Default value: `CLANDRO_APP__`
export CLANDRO_ENV__SS_CLANDRO_ROOTFS := ROOTFS__# Default value: `ROOTFS__`
export CLANDRO_ENV__S_CLANDRO_ROOTFS := $(CLANDRO_ENV__S_ROOT)$(CLANDRO_ENV__SS_CLANDRO_ROOTFS)# Default value: `CLANDRO_ROOTFS__`
export CLANDRO_ENV__SS_CLANDRO_EXEC := EXEC__# Default value: `EXEC__`
export CLANDRO_ENV__S_CLANDRO_EXEC := $(CLANDRO_ENV__S_ROOT)$(CLANDRO_ENV__SS_CLANDRO_EXEC)# Default value: `CLANDRO_EXEC__`
export CLANDRO_ENV__SS_CLANDRO_EXEC__TESTS := EXEC__TESTS__# Default value: `EXEC__TESTS__`
export CLANDRO_ENV__S_CLANDRO_EXEC__TESTS := $(CLANDRO_ENV__S_ROOT)$(CLANDRO_ENV__SS_CLANDRO_EXEC__TESTS)# Default value: `CLANDRO_EXEC__TESTS__`


# If architecture not set, find it for the compiler based on which
# predefined architecture macro is defined. The `shell` function
# replaces newlines with a space and a literal space cannot be entered
# in a makefile as its used as a splitter, hence $(SPACE) variable is
# created and used for matching.
ifeq ($(CLANDRO_EXEC_PKG__ARCH),)
	export override PREDEFINED_MACROS := $(shell $(CC) -x c /dev/null -dM -E)
	override EMPTY :=
	override SPACE := $(EMPTY) $(EMPTY)
	ifneq (,$(findstring $(SPACE)#define __i686__ 1$(SPACE),$(SPACE)$(PREDEFINED_MACROS)$(SPACE)))
		override CLANDRO_EXEC_PKG__ARCH := i686
	else ifneq (,$(findstring $(SPACE)#define __x86_64__ 1$(SPACE),$(SPACE)$(PREDEFINED_MACROS)$(SPACE)))
		override CLANDRO_EXEC_PKG__ARCH := x86_64
	else ifneq (,$(findstring $(SPACE)#define __aarch64__ 1$(SPACE),$(SPACE)$(PREDEFINED_MACROS)$(SPACE)))
		override CLANDRO_EXEC_PKG__ARCH := aarch64
	else ifneq (,$(findstring $(SPACE)#define __arm__ 1$(SPACE),$(SPACE)$(PREDEFINED_MACROS)$(SPACE)))
		override CLANDRO_EXEC_PKG__ARCH := arm
	else ifneq (,$(findstring $(SPACE)#define __riscv 1$(SPACE),$(SPACE)$(PREDEFINED_MACROS)$(SPACE)))
		override CLANDRO_EXEC_PKG__ARCH := riscv64
	else
        $(error Unsupported package arch)
	endif
endif


export override IS_ON_DEVICE_BUILD := $(shell test -f "/system/bin/app_process" && echo 1 || echo 0)



export override BUILD_DIR := build# Default value: `build`

export override BUILD_OUTPUT_DIR := $(BUILD_DIR)/output# Default value: `build/output`

export override TMP_BUILD_OUTPUT_DIR := $(BUILD_OUTPUT_DIR)/tmp# Default value: `build/output/tmp`

export override PREFIX_BUILD_OUTPUT_DIR := $(BUILD_OUTPUT_DIR)/usr# Default value: `build/output/usr`
export override BIN_BUILD_OUTPUT_DIR := $(PREFIX_BUILD_OUTPUT_DIR)/bin# Default value: `build/output/usr/bin`
export override LIB_BUILD_OUTPUT_DIR := $(PREFIX_BUILD_OUTPUT_DIR)/lib# Default value: `build/output/usr/lib`
export override LIBEXEC_BUILD_OUTPUT_DIR := $(PREFIX_BUILD_OUTPUT_DIR)/libexec# Default value: `build/output/usr/libexec`
export override TESTS_BUILD_OUTPUT_DIR := $(LIBEXEC_BUILD_OUTPUT_DIR)/installed-tests/clandro-exec# Default value: `build/output/usr/libexec/installed-tests/clandro-exec`

export override PACKAGING_BUILD_OUTPUT_DIR := $(BUILD_OUTPUT_DIR)/packaging# Default value: `build/output/packaging`
export override DEBIAN_PACKAGING_BUILD_OUTPUT_DIR := $(PACKAGING_BUILD_OUTPUT_DIR)/debian# Default value: `build/output/packaging/debian`



export override BUILD_INSTALL_DIR := $(BUILD_DIR)/install# Default value: `build/install`
export override PREFIX_BUILD_INSTALL_DIR := $(BUILD_INSTALL_DIR)/usr# Default value: `build/install/usr`

ifeq ($(CLANDRO_EXEC_PKG__INSTALL_PREFIX),)
	ifeq ($(DESTDIR)$(PREFIX),)
		override CLANDRO_EXEC_PKG__INSTALL_PREFIX := $(CLANDRO__PREFIX)
	else
		override CLANDRO_EXEC_PKG__INSTALL_PREFIX := $(DESTDIR)$(PREFIX)
	endif
endif
export CLANDRO_EXEC_PKG__INSTALL_PREFIX



export override CLANDRO__CONSTANTS__MACRO_FLAGS := \
	-DCLANDRO_EXEC_PKG__VERSION=\"$(CLANDRO_EXEC_PKG__VERSION)\" \
	-DCLANDRO__NAME=\"$(CLANDRO__NAME)\" \
	-DCLANDRO__LNAME=\"$(CLANDRO__LNAME)\" \
	-DCLANDRO__REPOS_HOST_ORG_NAME=\"$(CLANDRO__REPOS_HOST_ORG_NAME)\" \
	-DCLANDRO_APP__DATA_DIR=\"$(CLANDRO_APP__DATA_DIR)\" \
	-DCLANDRO__ROOTFS=\"$(CLANDRO__ROOTFS)\" \
	-DCLANDRO__PREFIX=\"$(CLANDRO__PREFIX)\" \
	-DCLANDRO__PREFIX__BIN_DIR=\"$(CLANDRO__PREFIX__BIN_DIR)\" \
	-DCLANDRO_ENV__S_CLANDRO=\"$(CLANDRO_ENV__S_CLANDRO)\" \
	-DCLANDRO_ENV__S_CLANDRO_APP=\"$(CLANDRO_ENV__S_CLANDRO_APP)\" \
	-DCLANDRO_ENV__S_CLANDRO_ROOTFS=\"$(CLANDRO_ENV__S_CLANDRO_ROOTFS)\" \
	-DCLANDRO_ENV__S_CLANDRO_EXEC=\"$(CLANDRO_ENV__S_CLANDRO_EXEC)\" \
	-DCLANDRO_ENV__S_CLANDRO_EXEC__TESTS=\"$(CLANDRO_ENV__S_CLANDRO_EXEC__TESTS)\"

export override CLANDRO__CONSTANTS__SED_ARGS := \
	-e "s%[@]CLANDRO_EXEC_PKG__VERSION[@]%$(CLANDRO_EXEC_PKG__VERSION)%g" \
	-e "s%[@]CLANDRO_EXEC_PKG__ARCH[@]%$(CLANDRO_EXEC_PKG__ARCH)%g" \
	-e "s%[@]CLANDRO__LNAME[@]%$(CLANDRO__LNAME)%g" \
	-e "s%[@]CLANDRO__REPOS_HOST_ORG_NAME[@]%$(CLANDRO__REPOS_HOST_ORG_NAME)%g" \
	-e "s%[@]CLANDRO_APP__NAME[@]%$(CLANDRO_APP__NAME)%g" \
	-e "s%[@]CLANDRO_APP__PACKAGE_NAME[@]%$(CLANDRO_APP__PACKAGE_NAME)%g" \
	-e "s%[@]CLANDRO_APP__DATA_DIR[@]%$(CLANDRO_APP__DATA_DIR)%g" \
	-e "s%[@]CLANDRO__ROOTFS[@]%$(CLANDRO__ROOTFS)%g" \
	-e "s%[@]CLANDRO__PREFIX[@]%$(CLANDRO__PREFIX)%g" \
	-e "s%[@]CLANDRO_ENV__S_CLANDRO[@]%$(CLANDRO_ENV__S_CLANDRO)%g" \
	-e "s%[@]CLANDRO_ENV__S_CLANDRO_APP[@]%$(CLANDRO_ENV__S_CLANDRO_APP)%g" \
	-e "s%[@]CLANDRO_ENV__S_CLANDRO_EXEC[@]%$(CLANDRO_ENV__S_CLANDRO_EXEC)%g" \
	-e "s%[@]CLANDRO_ENV__S_CLANDRO_EXEC__TESTS[@]%$(CLANDRO_ENV__S_CLANDRO_EXEC__TESTS)%g"

define replace-clandro-constants
	sed $(CLANDRO__CONSTANTS__SED_ARGS) "$1.in" > "$2/$$(basename "$1")"
endef



export override CFLAGS_DEFAULT :=
export override CPPFLAGS_DEFAULT :=
export override LDFLAGS_DEFAULT :=

# If building with make directly without clandro-pacakges build infrastructure,
# then allow custom path for `libclandro-core_*.a` as they may not be
# installed in `CLANDRO__PREFIX__LIB_DIR`.
ifeq ($(LDFLAGS),)
	ifneq ($(CLANDRO_CORE_PKG__INSTALL_PREFIX),)
		ifneq ($(shell test -d "$(CLANDRO_CORE_PKG__INSTALL_PREFIX)" && echo 1 || echo 0), 1)
            $(error The clandro-core package install prefix directory does not exist at CLANDRO_CORE_PKG__INSTALL_PREFIX '$(CLANDRO_CORE_PKG__INSTALL_PREFIX)' path)
		endif
		override CPPFLAGS_DEFAULT += -I$(CLANDRO_CORE_PKG__INSTALL_PREFIX)/include/clandro-core
		override LDFLAGS_DEFAULT += -L$(CLANDRO_CORE_PKG__INSTALL_PREFIX)/lib
	endif
endif

override CPPFLAGS_DEFAULT += -isystem$(CLANDRO__PREFIX__INCLUDE_DIR)
override LDFLAGS_DEFAULT += -L$(CLANDRO__PREFIX__LIB_DIR)

ifeq ($(CLANDRO_EXEC_PKG__ARCH),arm)
	# "We recommend using the -mthumb compiler flag to force the generation of 16-bit Thumb-2 instructions".
	# - https://developer.android.com/ndk/guides/standalone_toolchain.html#abi_compatibility
	override CFLAGS_DEFAULT += -march=armv7-a -mfpu=neon -mfloat-abi=softfp -mthumb
	override LDFLAGS_DEFAULT += -march=armv7-a
else ifeq ($(CLANDRO_EXEC_PKG__ARCH),i686)
	# From $NDK/docs/CPU-ARCH-ABIS.html:
	override CFLAGS_DEFAULT += -march=i686 -msse3 -mstackrealign -mfpmath=sse
	# i686 seem to explicitly require '-fPIC'.
	# - https://github.com/cl-andro/clandro-packages/issues/7215#issuecomment-906154438
	override CFLAGS_DEFAULT += -fPIC
endif

# - https://github.com/cl-andro/clandro-packages/commit/b997c4ea
ifeq ($(IS_ON_DEVICE_BUILD), 0)
	override LDFLAGS_DEFAULT += -Wl,-rpath=$(CLANDRO__PREFIX__LIB_DIR)
endif

# Android 7 started to support DT_RUNPATH (but not DT_RPATH).
override LDFLAGS_DEFAULT += -Wl,--enable-new-dtags

# Avoid linking extra (unneeded) libraries.
override LDFLAGS_DEFAULT += -Wl,--as-needed

# Basic hardening.
override LDFLAGS_DEFAULT += -Wl,-z,relro,-z,now


# Set default flags if building with make directly without clandro-pacakges build infrastructure.
CFLAGS ?= $(CFLAGS_DEFAULT)
CXXFLAGS ?= $(CFLAGS_DEFAULT)
CPPFLAGS ?= $(CPPFLAGS_DEFAULT)
LDFLAGS ?= $(LDFLAGS_DEFAULT)

# Force optimize for speed and do basic hardening.
export override CFLAGS_FORCE := -Wall -Wextra -Werror -Wshadow -O2 -D_FORTIFY_SOURCE=2 -fstack-protector-strong

CFLAGS += $(CFLAGS_FORCE)
CXXFLAGS += $(CFLAGS_FORCE)

FSANTIZE_FLAGS += -fsanitize=address -fsanitize-recover=address -fno-omit-frame-pointer



override LIBCLANDRO_EXEC__NOS__C__SOURCE_FILES := \
	lib/clandro-exec_nos_c/tre/src/ClandroExecLibraryConfig.c \
	lib/clandro-exec_nos_c/tre/src/clandro/api/clandro_exec/service/ld_preload/ClandroExecLDPreload.c \
	lib/clandro-exec_nos_c/tre/src/clandro/api/clandro_exec/service/ld_preload/direct/exec/ExecIntercept.c \
	lib/clandro-exec_nos_c/tre/src/clandro/api/clandro_exec/service/ld_preload/direct/exec/ExecVariantsIntercept.c \
	lib/clandro-exec_nos_c/tre/src/clandro/os/process/clandro_exec/ClandroExecProcess.c \
	lib/clandro-exec_nos_c/tre/src/clandro/shell/command/environment/clandro_exec/ClandroExecShellEnvironment.c

override LIBCLANDRO_EXEC__NOS__C__OBJECT_FILES := $(patsubst lib/%.c,$(TMP_BUILD_OUTPUT_DIR)/lib/%.o,$(LIBCLANDRO_EXEC__NOS__C__SOURCE_FILES))

override LIBCLANDRO_EXEC__NOS__C__CPPFLAGS := \
	$(CPPFLAGS) -I "$(CLANDRO__PREFIX)/include/clandro-core" -I "lib/clandro-exec_nos_c/tre/include"

override LIBCLANDRO_EXEC__NOS__C__TESTS_BUILD_OUTPUT_DIR := $(TESTS_BUILD_OUTPUT_DIR)/lib/clandro-exec_nos_c/tre


ifneq ($(LIBCLANDRO_EXEC__NOS__C__EXECVE_CALL__CHECK_ARGV0_BUFFER_OVERFLOW),1)
	override LIBCLANDRO_EXEC__NOS__C__EXECVE_CALL__CHECK_ARGV0_BUFFER_OVERFLOW := 0
endif



override CLANDRO_EXEC__MAIN_APP__TESTS_BUILD_OUTPUT_DIR := $(TESTS_BUILD_OUTPUT_DIR)/app/main



# The `-L` flag must come before `$LDFLAGS`, otherwise old library
# installed in system library directory from previous builds
# will get used instead of newly built one in `$LIB_BUILD_OUTPUT_DIR`.
# The `-fvisibility=hidden` flag is passed so that no internal
# functions are exported. All exported functions must explicitly enable
# `default` visibility with `__attribute__((visibility("default")))`,
# like for the `main()` function.
# The `-Wl,--exclude-libs=ALL` flag is passed so that symbols from
# the `libclandro-core_nos_c_tre.a` static library linked are not exported.
# Run `nm --demangle --defined-only --extern-only <executable>` to
# find exported symbols.
override CLANDRO_EXEC_EXECUTABLE__C__BUILD_COMMAND := \
	$(CC) $(CFLAGS) $(LIBCLANDRO_EXEC__NOS__C__CPPFLAGS) \
	-L$(LIB_BUILD_OUTPUT_DIR) $(LDFLAGS) -Wl,--exclude-libs=ALL \
	$(CLANDRO__CONSTANTS__MACRO_FLAGS) \
	-fPIE -pie -fvisibility=hidden

# The `-l` flags must be passed after object files for proper linking.
# The order of libraries matters too and any dependencies of a library
# must come after it.
override CLANDRO_EXEC_EXECUTABLE__C__POST_LDFLAGS := -l:libclandro-exec_nos_c_tre.a -l:libclandro-core_nos_c_tre.a


CLANG_FORMAT := clang-format --sort-includes --style="{ColumnLimit: 120}"
CLANG_TIDY ?= clang-tidy



# - https://www.gnu.org/software/make/manual/html_node/Parallel-Disable.html
.NOTPARALLEL:

all: | pre-build build-libclandro-exec_nos_c_tre build-libclandro-exec-direct-ld-preload build-libclandro-exec-linker-ld-preload build-clandro-exec-main-app
	@printf "\nclandro-exec-package: %s\n" "Building packaging/debian/*"
	@mkdir -p $(DEBIAN_PACKAGING_BUILD_OUTPUT_DIR)
	find packaging/debian -mindepth 1 -maxdepth 1 -type f -name "*.in" -exec sh -c \
		'sed $(CLANDRO__CONSTANTS__SED_ARGS) "$$1" > $(DEBIAN_PACKAGING_BUILD_OUTPUT_DIR)/"$$(basename "$$1" | sed "s/\.in$$//")"' sh "{}" \;
	find $(DEBIAN_PACKAGING_BUILD_OUTPUT_DIR) -mindepth 1 -maxdepth 1 -type f \
		-regextype posix-extended -regex "^.*/(postinst|postrm|preinst|prerm)$$" \
		-exec chmod 700 {} \;
	find $(DEBIAN_PACKAGING_BUILD_OUTPUT_DIR) -mindepth 1 -maxdepth 1 -type f \
		-regextype posix-extended -regex "^.*/(config|conffiles|templates|triggers|clilibs|fortran_mod|runit|shlibs|starlibs|symbols)$$" \
		-exec chmod 600 {} \;


	@printf "\nclandro-exec-package: %s\n\n" "Build clandro-exec-package successful"

pre-build: | clean
	@printf "clandro-exec-package: %s\n" "Building clandro-exec-package"
	@mkdir -p $(BUILD_OUTPUT_DIR)
	@mkdir -p $(TMP_BUILD_OUTPUT_DIR)

build-clandro-exec-main-app:
	@printf "\nclandro-exec-package: %s\n" "Building app/main"
	@mkdir -p $(BIN_BUILD_OUTPUT_DIR)


	@printf "\nclandro-exec-package: %s\n" "Building app/main/scripts/*"
	find app/main/scripts -type f -name "*.in" -exec sh -c \
		'sed $(CLANDRO__CONSTANTS__SED_ARGS) "$$1" > $(BIN_BUILD_OUTPUT_DIR)/"$$(basename "$$1" | sed "s/\.in$$//")"' sh "{}" \;
	find $(BIN_BUILD_OUTPUT_DIR) -maxdepth 1 -exec chmod 700 "{}" \;
	find app/main/scripts -type l -exec cp -a "{}" $(BIN_BUILD_OUTPUT_DIR)/ \;


	@printf "\nclandro-exec-package: %s\n" "Building app/main/tests/*"
	@mkdir -p $(CLANDRO_EXEC__MAIN_APP__TESTS_BUILD_OUTPUT_DIR)
	find app/main/tests -maxdepth 1 -type f -name "*.in" -print0 | xargs -0 -n1 sh -c \
		'output_file="$(CLANDRO_EXEC__MAIN_APP__TESTS_BUILD_OUTPUT_DIR)/$$(printf "%s" "$$0" | sed -e "s|^app/main/tests/||" -e "s/\.in$$//")" && mkdir -p "$$(dirname "$$output_file")" && sed $(CLANDRO__CONSTANTS__SED_ARGS) "$$0" > "$$output_file"'
	find $(CLANDRO_EXEC__MAIN_APP__TESTS_BUILD_OUTPUT_DIR) -maxdepth 1 -type f -exec chmod 700 "{}" \;

build-libclandro-exec_nos_c_tre:
	@printf "\nclandro-exec-package: %s\n" "Building lib/clandro-exec_nos_c_tre"
	@mkdir -p $(LIB_BUILD_OUTPUT_DIR)

	@printf "\nclandro-exec-package: %s\n" "Building lib/clandro-exec_nos_c/tre/lib/*.o"
	for source_file in $(LIBCLANDRO_EXEC__NOS__C__SOURCE_FILES); do \
		mkdir -p "$$(dirname "$(TMP_BUILD_OUTPUT_DIR)/$$source_file")" || exit $$?; \
		$(CC) -c $(CFLAGS) $(LIBCLANDRO_EXEC__NOS__C__CPPFLAGS) \
			$(CLANDRO__CONSTANTS__MACRO_FLAGS) \
			-DLIBCLANDRO_EXEC__NOS__C__EXECVE_CALL__CHECK_ARGV0_BUFFER_OVERFLOW=$(LIBCLANDRO_EXEC__NOS__C__EXECVE_CALL__CHECK_ARGV0_BUFFER_OVERFLOW) \
			-fPIC -fvisibility=default \
			-o $(TMP_BUILD_OUTPUT_DIR)/"$$(echo "$$source_file" | sed -E "s/(.*)\.c$$/\1.o/")" \
			"$$source_file" || exit $$?; \
	done

	@# `nm --demangle --dynamic --defined-only --extern-only /home/builder/.clandro-build/clandro-exec/src/build/output/usr/lib/libclandro-exec_nos_c_tre.so`
	@printf "\nclandro-exec-package: %s\n" "Building lib/libclandro-exec_nos_c_tre.so"
	$(CC) $(CFLAGS) $(LIBCLANDRO_EXEC__NOS__C__CPPFLAGS) \
		-L$(LIB_BUILD_OUTPUT_DIR) $(LDFLAGS) -Wl,--exclude-libs=ALL \
		$(CLANDRO__CONSTANTS__MACRO_FLAGS) \
		-fPIC -shared -fvisibility=default \
		-o $(LIB_BUILD_OUTPUT_DIR)/libclandro-exec_nos_c_tre.so \
		$(LIBCLANDRO_EXEC__NOS__C__OBJECT_FILES) \
		-l:libclandro-core_nos_c_tre.a

	@printf "\nclandro-exec-package: %s\n" "Building lib/libclandro-exec_nos_c_tre.a"
	$(AR) rcs $(LIB_BUILD_OUTPUT_DIR)/libclandro-exec_nos_c_tre.a $(LIBCLANDRO_EXEC__NOS__C__OBJECT_FILES)



	@printf "\nclandro-exec-package: %s\n" "Building lib/clandro-exec_nos_c/tre/tests/*"
	@mkdir -p $(LIBCLANDRO_EXEC__NOS__C__TESTS_BUILD_OUTPUT_DIR)


	@printf "\nclandro-exec-package: %s\n" "Building lib/clandro-exec_nos_c/tre/tests/libclandro-exec_nos_c_tre_tests"
	$(call replace-clandro-constants,lib/clandro-exec_nos_c/tre/tests/libclandro-exec_nos_c_tre_tests,$(LIBCLANDRO_EXEC__NOS__C__TESTS_BUILD_OUTPUT_DIR))
	chmod 700 $(LIBCLANDRO_EXEC__NOS__C__TESTS_BUILD_OUTPUT_DIR)/libclandro-exec_nos_c_tre_tests


	@printf "\nclandro-exec-package: %s\n" "Building lib/clandro-exec_nos_c/tre/tests/bin/libclandro-exec_nos_c_tre_unit-binary-tests"
	@mkdir -p $(LIBCLANDRO_EXEC__NOS__C__TESTS_BUILD_OUTPUT_DIR)/bin

	@# `nm --demangle --defined-only --extern-only /home/builder/.clandro-build/clandro-exec/src/build/output/usr/libexec/installed-tests/clandro-exec/lib/clandro-exec_nos_c/tre/bin/libclandro-exec_nos_c_tre_unit-binary-tests-fsanitize`
	$(CLANDRO_EXEC_EXECUTABLE__C__BUILD_COMMAND) -O0 -g \
		$(FSANTIZE_FLAGS) \
		-o $(LIBCLANDRO_EXEC__NOS__C__TESTS_BUILD_OUTPUT_DIR)/bin/libclandro-exec_nos_c_tre_unit-binary-tests-fsanitize \
		lib/clandro-exec_nos_c/tre/tests/src/libclandro-exec_nos_c_tre_unit-binary-tests.c \
		$(CLANDRO_EXEC_EXECUTABLE__C__POST_LDFLAGS)

	@# `nm --demangle --defined-only --extern-only /home/builder/.clandro-build/clandro-exec/src/build/output/usr/libexec/installed-tests/clandro-exec/lib/clandro-exec_nos_c/tre/bin/libclandro-exec_nos_c_tre_unit-binary-tests-nofsanitize`
	$(CLANDRO_EXEC_EXECUTABLE__C__BUILD_COMMAND) -O0 -g \
		-o $(LIBCLANDRO_EXEC__NOS__C__TESTS_BUILD_OUTPUT_DIR)/bin/libclandro-exec_nos_c_tre_unit-binary-tests-nofsanitize \
		lib/clandro-exec_nos_c/tre/tests/src/libclandro-exec_nos_c_tre_unit-binary-tests.c \
		$(CLANDRO_EXEC_EXECUTABLE__C__POST_LDFLAGS)


	@printf "\nclandro-exec-package: %s\n" "Building lib/clandro-exec_nos_c/tre/tests/bin/libclandro-exec_nos_c_tre_runtime-binary-tests$(CLANDRO_EXEC_PKG__TESTS__API_LEVEL)"
	@mkdir -p $(LIBCLANDRO_EXEC__NOS__C__TESTS_BUILD_OUTPUT_DIR)/bin

	$(CLANDRO_EXEC_EXECUTABLE__C__BUILD_COMMAND) -O0 -g \
		$(FSANTIZE_FLAGS) \
		-o $(LIBCLANDRO_EXEC__NOS__C__TESTS_BUILD_OUTPUT_DIR)/bin/libclandro-exec_nos_c_tre_runtime-binary-tests-fsanitize$(CLANDRO_EXEC_PKG__TESTS__API_LEVEL) \
		lib/clandro-exec_nos_c/tre/tests/src/libclandro-exec_nos_c_tre_runtime-binary-tests.c \
		$(CLANDRO_EXEC_EXECUTABLE__C__POST_LDFLAGS)
	$(CLANDRO_EXEC_EXECUTABLE__C__BUILD_COMMAND) -O0 -g \
		-o $(LIBCLANDRO_EXEC__NOS__C__TESTS_BUILD_OUTPUT_DIR)/bin/libclandro-exec_nos_c_tre_runtime-binary-tests-nofsanitize$(CLANDRO_EXEC_PKG__TESTS__API_LEVEL) \
		lib/clandro-exec_nos_c/tre/tests/src/libclandro-exec_nos_c_tre_runtime-binary-tests.c \
		$(CLANDRO_EXEC_EXECUTABLE__C__POST_LDFLAGS)


	@printf "\nclandro-exec-package: %s\n" "Building lib/clandro-exec_nos_c/tre/tests/scripts/*"
	@mkdir -p $(LIBCLANDRO_EXEC__NOS__C__TESTS_BUILD_OUTPUT_DIR)/scripts
	find lib/clandro-exec_nos_c/tre/tests/scripts -type f -name '*.c' -print0 | xargs -0 -n1 sh -c \
		'output_file="$(LIBCLANDRO_EXEC__NOS__C__TESTS_BUILD_OUTPUT_DIR)/scripts/$$(printf "%s" "$$0" | sed -e "s|^lib/clandro-exec_nos_c/tre/tests/scripts/||" -e "s/\.c$$//")" && mkdir -p "$$(dirname "$$output_file")" && $(CC) $(CFLAGS) -O0 -fPIE -pie $(LDFLAGS) -g "$$0" -o "$$output_file"'
	find lib/clandro-exec_nos_c/tre/tests/scripts -type f -name '*.sh' -print0 | xargs -0 -n1 sh -c \
		'output_file="$(LIBCLANDRO_EXEC__NOS__C__TESTS_BUILD_OUTPUT_DIR)/scripts/$$(printf "%s" "$$0" | sed -e "s|^lib/clandro-exec_nos_c/tre/tests/scripts/||")" && mkdir -p "$$(dirname "$$output_file")" && cp -a "$$0" "$$output_file"'
	find lib/clandro-exec_nos_c/tre/tests/scripts -type f -name "*.in" -print0 | xargs -0 -n1 sh -c \
		'output_file="$(LIBCLANDRO_EXEC__NOS__C__TESTS_BUILD_OUTPUT_DIR)/scripts/$$(printf "%s" "$$0" | sed -e "s|^lib/clandro-exec_nos_c/tre/tests/scripts/||" -e "s/\.in$$//")" && mkdir -p "$$(dirname "$$output_file")" && sed $(CLANDRO__CONSTANTS__SED_ARGS) "$$0" > "$$output_file"'
	find lib/clandro-exec_nos_c/tre/tests/scripts -type l -print0 | xargs -0 -n1 sh -c \
		'output_file="$(LIBCLANDRO_EXEC__NOS__C__TESTS_BUILD_OUTPUT_DIR)/scripts/$$(printf "%s" "$$0" | sed -e "s|^lib/clandro-exec_nos_c/tre/tests/scripts/||")" && mkdir -p "$$(dirname "$$output_file")" && cp -a "$$0" "$$output_file"'
	find $(LIBCLANDRO_EXEC__NOS__C__TESTS_BUILD_OUTPUT_DIR)/scripts -type f -exec chmod 700 "{}" \;


build-libclandro-exec_nos_c_tre_runtime-binary-tests:
	@printf "clandro-exec-package: %s\n" "Building lib/clandro-exec_nos_c/tre/tests/bin/libclandro-exec_nos_c_tre_runtime-binary-tests$(CLANDRO_EXEC_PKG__TESTS__API_LEVEL)"
	@mkdir -p $(LIBCLANDRO_EXEC__NOS__C__TESTS_BUILD_OUTPUT_DIR)/bin

	$(CLANDRO_EXEC_EXECUTABLE__C__BUILD_COMMAND) -O0 -g \
		$(FSANTIZE_FLAGS) \
		-o $(LIBCLANDRO_EXEC__NOS__C__TESTS_BUILD_OUTPUT_DIR)/bin/libclandro-exec_nos_c_tre_runtime-binary-tests-fsanitize$(CLANDRO_EXEC_PKG__TESTS__API_LEVEL) \
		lib/clandro-exec_nos_c/tre/tests/src/libclandro-exec_nos_c_tre_runtime-binary-tests.c \
		$(CLANDRO_EXEC_EXECUTABLE__C__POST_LDFLAGS)
	$(CLANDRO_EXEC_EXECUTABLE__C__BUILD_COMMAND) -O0 -g \
		-o $(LIBCLANDRO_EXEC__NOS__C__TESTS_BUILD_OUTPUT_DIR)/bin/libclandro-exec_nos_c_tre_runtime-binary-tests-nofsanitize$(CLANDRO_EXEC_PKG__TESTS__API_LEVEL) \
		lib/clandro-exec_nos_c/tre/tests/src/libclandro-exec_nos_c_tre_runtime-binary-tests.c \
		$(CLANDRO_EXEC_EXECUTABLE__C__POST_LDFLAGS)

build-libclandro-exec-direct-ld-preload:
	@mkdir -p $(LIB_BUILD_OUTPUT_DIR)

	@# Unlike `libclandro-exec_nos_c_tre.so` and `libclandro-exec_nos_c_tre.a`, all
	@# symbols are hidden, except the exported functions with
	@# `default` visibility with `__attribute__((visibility("default")))`,
	@# defined in the `ClandroExecDirectLDPreloadEntryPoint.c` file meant to
	@# be intercepted by `$LD_PRELOAD`.
	@# `nm --demangle --dynamic --defined-only --extern-only /home/builder/.clandro-build/clandro-exec/src/build/output/usr/lib/libclandro-exec-direct-ld-preload.so`
	@printf "\nclandro-exec-package: %s\n" "Building lib/libclandro-exec-direct-ld-preload"
	$(CC) $(CFLAGS) $(LIBCLANDRO_EXEC__NOS__C__CPPFLAGS) \
		-L$(LIB_BUILD_OUTPUT_DIR) $(LDFLAGS) -Wl,--exclude-libs=ALL \
		$(CLANDRO__CONSTANTS__MACRO_FLAGS) \
		-fPIC -shared -fvisibility=hidden \
		-o $(LIB_BUILD_OUTPUT_DIR)/libclandro-exec-direct-ld-preload.so \
		app/clandro-exec-direct-ld-preload/src/clandro/api/clandro_exec/service/ld_preload/direct/ClandroExecDirectLDPreloadEntryPoint.c \
		-l:libclandro-exec_nos_c_tre.a -l:libclandro-core_nos_c_tre.a

	@# By default, set `libclandro-exec-direct-ld-preload.so` as the
	@# primary library variant exported in `$LD_PRELOAD` by copying it
	@# to `libclandro-exec-ld-preload.so`.
	@# Creating a symlink may have performance impacts.
	@# The `postinst` script run during package installation runs
	@# `clandro-exec-ld-preload-lib setup` to set the correct variant
	@# as per the execution type required for the Clandro environment
	@# of the host device by running.
	cp -a $(LIB_BUILD_OUTPUT_DIR)/libclandro-exec-direct-ld-preload.so $(LIB_BUILD_OUTPUT_DIR)/libclandro-exec-ld-preload.so

	@# For backward compatibility, symlink `libclandro-exec.so` to
	@# `libclandro-exec-ld-preload.so` so that older clients do not
	@# break which have exported path to `libclandro-exec.so` in
	@# `$LD_PRELOAD` via `login` script of older versions of
	@# `clandro-tools `package.
	rm -f $(LIB_BUILD_OUTPUT_DIR)/libclandro-exec.so
	ln -s libclandro-exec-ld-preload.so $(LIB_BUILD_OUTPUT_DIR)/libclandro-exec.so

build-libclandro-exec-linker-ld-preload:
	@mkdir -p $(LIB_BUILD_OUTPUT_DIR)

	@# Unlike `libclandro-exec_nos_c_tre.so` and `libclandro-exec_nos_c_tre.a`, all
	@# symbols are hidden, except the exported functions with
	@# `default` visibility with `__attribute__((visibility("default")))`,
	@# defined in the `ClandroExecLinkerLDPreloadEntryPoint.c` file meant to
	@# be intercepted by `$LD_PRELOAD`.
	@# `nm --demangle --dynamic --defined-only --extern-only /home/builder/.clandro-build/clandro-exec/src/build/output/usr/lib/libclandro-exec-linker-ld-preload.so`
	@printf "\nclandro-exec-package: %s\n" "Building lib/libclandro-exec-linker-ld-preload"
	$(CC) $(CFLAGS) $(LIBCLANDRO_EXEC__NOS__C__CPPFLAGS) \
		-L$(LIB_BUILD_OUTPUT_DIR) $(LDFLAGS) -Wl,--exclude-libs=ALL \
		$(CLANDRO__CONSTANTS__MACRO_FLAGS) \
		-fPIC -shared -fvisibility=hidden \
		-o $(LIB_BUILD_OUTPUT_DIR)/libclandro-exec-linker-ld-preload.so \
		app/clandro-exec-linker-ld-preload/src/clandro/api/clandro_exec/service/ld_preload/linker/ClandroExecLinkerLDPreloadEntryPoint.c \
		-l:libclandro-exec_nos_c_tre.a -l:libclandro-core_nos_c_tre.a



clean:
	rm -rf $(BUILD_OUTPUT_DIR)

install:
	@printf "clandro-exec-package: %s\n" "Installing clandro-exec-package in $(CLANDRO_EXEC_PKG__INSTALL_PREFIX)"
	install -d $(CLANDRO_EXEC_PKG__INSTALL_PREFIX)/bin
	install -d $(CLANDRO_EXEC_PKG__INSTALL_PREFIX)/include
	install -d $(CLANDRO_EXEC_PKG__INSTALL_PREFIX)/lib
	install -d $(CLANDRO_EXEC_PKG__INSTALL_PREFIX)/libexec


	find $(BIN_BUILD_OUTPUT_DIR) -maxdepth 1 \( -type f -o -type l \) -exec cp -a "{}" $(CLANDRO_EXEC_PKG__INSTALL_PREFIX)/bin/ \;

	rm -rf $(CLANDRO_EXEC_PKG__INSTALL_PREFIX)/include/clandro-exec
	install -d $(CLANDRO_EXEC_PKG__INSTALL_PREFIX)/include/clandro-exec/clandro

	cp -a lib/clandro-exec_nos_c/tre/include/clandro/clandro_exec__nos__c $(CLANDRO_EXEC_PKG__INSTALL_PREFIX)/include/clandro-exec/clandro/clandro_exec__nos__c
	install $(LIB_BUILD_OUTPUT_DIR)/libclandro-exec_nos_c_tre.so $(CLANDRO_EXEC_PKG__INSTALL_PREFIX)/lib/libclandro-exec_nos_c_tre.so
	install $(LIB_BUILD_OUTPUT_DIR)/libclandro-exec_nos_c_tre.a $(CLANDRO_EXEC_PKG__INSTALL_PREFIX)/lib/libclandro-exec_nos_c_tre.a

	install $(LIB_BUILD_OUTPUT_DIR)/libclandro-exec-ld-preload.so $(CLANDRO_EXEC_PKG__INSTALL_PREFIX)/lib/libclandro-exec-ld-preload.so
	install $(LIB_BUILD_OUTPUT_DIR)/libclandro-exec-direct-ld-preload.so $(CLANDRO_EXEC_PKG__INSTALL_PREFIX)/lib/libclandro-exec-direct-ld-preload.so
	install $(LIB_BUILD_OUTPUT_DIR)/libclandro-exec-linker-ld-preload.so $(CLANDRO_EXEC_PKG__INSTALL_PREFIX)/lib/libclandro-exec-linker-ld-preload.so
	@# Use `cp` for symlink as `install` will copy the target regular file instead.
	cp -a $(LIB_BUILD_OUTPUT_DIR)/libclandro-exec.so $(CLANDRO_EXEC_PKG__INSTALL_PREFIX)/lib/libclandro-exec.so

	find $(CLANDRO_EXEC_PKG__INSTALL_PREFIX)/include/clandro-exec -type d -exec chmod 700 {} \;
	find $(CLANDRO_EXEC_PKG__INSTALL_PREFIX)/include/clandro-exec -type f -exec chmod 600 {} \;


	rm -rf $(CLANDRO_EXEC_PKG__INSTALL_PREFIX)/libexec/installed-tests/clandro-exec
	install -d $(CLANDRO_EXEC_PKG__INSTALL_PREFIX)/libexec/installed-tests
	cp -a $(TESTS_BUILD_OUTPUT_DIR) $(CLANDRO_EXEC_PKG__INSTALL_PREFIX)/libexec/installed-tests/clandro-exec

	@printf "\nclandro-exec-package: %s\n\n" "Install clandro-exec-package successful"

uninstall:
	@printf "clandro-exec-package: %s\n" "Uninstalling clandro-exec-package from $(CLANDRO_EXEC_PKG__INSTALL_PREFIX)"

	find app/main/scripts \( -type f -o -type l \) -exec sh -c \
		'rm -f $(CLANDRO_EXEC_PKG__INSTALL_PREFIX)/bin/"$$(basename "$$1" | sed "s/\.in$$//")"' sh "{}" \;

	rm -rf $(CLANDRO_EXEC_PKG__INSTALL_PREFIX)/include/clandro-exec


	rm -f $(CLANDRO_EXEC_PKG__INSTALL_PREFIX)/lib/libclandro-exec_nos_c_tre.so
	rm -f $(CLANDRO_EXEC_PKG__INSTALL_PREFIX)/lib/libclandro-exec_nos_c_tre.a

	rm -f $(CLANDRO_EXEC_PKG__INSTALL_PREFIX)/lib/libclandro-exec-ld-preload.so
	rm -f $(CLANDRO_EXEC_PKG__INSTALL_PREFIX)/lib/libclandro-exec-direct-ld-preload.so
	rm -f $(CLANDRO_EXEC_PKG__INSTALL_PREFIX)/lib/libclandro-exec-linker-ld-preload.so
	rm -f $(CLANDRO_EXEC_PKG__INSTALL_PREFIX)/lib/libclandro-exec.so


	rm -rf $(CLANDRO_EXEC_PKG__INSTALL_PREFIX)/libexec/installed-tests/clandro-exec

	@printf "\nclandro-exec-package: %s\n\n" "Uninstall clandro-exec-package successful"



packaging-debian-build: all
	clandro-create-package $(DEBIAN_PACKAGING_BUILD_OUTPUT_DIR)/clandro-exec-package.json



test: all
	$(MAKE) CLANDRO_EXEC_PKG__INSTALL_PREFIX=$(PREFIX_BUILD_INSTALL_DIR) install

	@printf "\nclandro-exec-package: %s\n" "Executing clandro-exec-package tests"
	bash $(PREFIX_BUILD_INSTALL_DIR)/libexec/installed-tests/clandro-exec/app/main/clandro-exec-tests \
		--tests-path="$(PREFIX_BUILD_INSTALL_DIR)/libexec/installed-tests/clandro-exec" \
		--ld-preload-dir="$(PREFIX_BUILD_INSTALL_DIR)/lib" \
		-vvv all

test-unit: all
	$(MAKE) CLANDRO_EXEC_PKG__INSTALL_PREFIX=$(PREFIX_BUILD_INSTALL_DIR) install

	@printf "\nclandro-exec-package: %s\n" "Executing clandro-exec-package unit tests"
	bash $(PREFIX_BUILD_INSTALL_DIR)/libexec/installed-tests/clandro-exec/app/main/clandro-exec-tests \
		--tests-path="$(PREFIX_BUILD_INSTALL_DIR)/libexec/installed-tests/clandro-exec" \
		-vvv unit

test-runtime: all
	$(MAKE) CLANDRO_EXEC_PKG__INSTALL_PREFIX=$(PREFIX_BUILD_INSTALL_DIR) install

	@printf "\nclandro-exec-package: %s\n" "Executing clandro-exec-package runtime tests"
	bash $(PREFIX_BUILD_INSTALL_DIR)/libexec/installed-tests/clandro-exec/app/main/clandro-exec-tests \
		--tests-path="$(PREFIX_BUILD_INSTALL_DIR)/libexec/installed-tests/clandro-exec" \
		--ld-preload-dir="$(PREFIX_BUILD_INSTALL_DIR)/lib" \
		-vvv runtime



format:
	$(CLANG_FORMAT) -i app/clandro-exec-direct-ld-preload/src/clandro/api/clandro_exec/service/ld_preload/direct/ClandroExecDirectLDPreloadEntryPoint.c $(LIBCLANDRO_EXEC__NOS__C__SOURCE_FILES)
check:
	$(CLANG_FORMAT) --dry-run app/clandro-exec-direct-ld-preload/src/clandro/api/clandro_exec/service/ld_preload/direct/ClandroExecDirectLDPreloadEntryPoint.c $(LIBCLANDRO_EXEC__NOS__C__SOURCE_FILES)
	$(CLANG_TIDY) -warnings-as-errors='*' \
		app/clandro-exec-direct-ld-preload/src/clandro/api/clandro_exec/service/ld_preload/direct/ClandroExecDirectLDPreloadEntryPoint.c $(LIBCLANDRO_EXEC__NOS__C__SOURCE_FILES) -- \
		$(LIBCLANDRO_EXEC__NOS__C__CPPFLAGS) \
		$(CLANDRO__CONSTANTS__MACRO_FLAGS)



.PHONY: all pre-build build-clandro-exec-main-app build-libclandro-exec_nos_c_tre build-libclandro-exec_nos_c_tre_runtime-binary-tests build-libclandro-exec-linker-ld-preload build-libclandro-exec-direct-ld-preload clean install uninstall packaging-debian-build test test-unit test-runtime format check
