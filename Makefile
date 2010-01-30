INSTALL = install
INSTALL_DIRECTORY = $(INSTALL) -d -m 0755
INSTALL_FILE = $(INSTALL) -m 0644
INSTALL_EXECUTABLE = $(INSTALL) -m 0755

DESTDIR :=
SYSCONFDIR := $(DESTDIR)/etc
BINDIR := $(DESTDIR)/usr/bin
PKGLIBDIR := $(DESTDIR)/usr/lib/pbuilder
SBINDIR := $(DESTDIR)/usr/sbin
EXAMPLEDIR := $(DESTDIR)/usr/share/doc/pbuilder/examples
EXAMPLE_LVMPBUILDERDIR := $(EXAMPLEDIR)/lvmpbuilder
EXAMPLE_LVMPBUILDER_LIBDIR := $(EXAMPLE_LVMPBUILDERDIR)/lib
EXAMPLE_PBUILDERTESTDIR := $(EXAMPLEDIR)/pbuilder-test
EXAMPLE_REBUILDDIR := $(EXAMPLEDIR)/rebuild
EXAMPLE_WORKAROUNDDIR := $(EXAMPLEDIR)/workaround
PKGDATADIR := $(DESTDIR)/usr/share/pbuilder

define newline


endef

NULL :=

BIN_SCRIPTS += \
	debuild-pbuilder \
	pbuilder-user-mode-linux \
	pdebuild \
	pdebuild-user-mode-linux \
	$(NULL)

PKGLIB_SCRIPTS += \
	pbuilder-buildpackage \
	pbuilder-buildpackage-funcs \
	pbuilder-checkparams \
	pbuilder-createbuildenv \
	pbuilder-loadconfig \
	pbuilder-modules \
	pbuilder-runhooks \
	pbuilder-satisfydepends-aptitude \
	pbuilder-satisfydepends-checkparams \
	pbuilder-satisfydepends-classic \
	pbuilder-satisfydepends-experimental \
	pbuilder-satisfydepends-funcs \
	pbuilder-satisfydepends-gdebi \
	pbuilder-uml-checkparams \
	pbuilder-updatebuildenv \
	pdebuild-checkparams \
	pdebuild-internal \
	pdebuild-uml-checkparams \
	$(NULL)
# TODO add pbuilder-apt-config

SBIN_SCRIPTS += \
	pbuilder \
	$(NULL)

EXAMPLE_DATA += \
	pbuilderrc \
	$(NULL)

EXAMPLE_SCRIPTS += \
	examples/B90lintian \
	examples/B91dpkg-i \
	examples/B92test-pkg \
	examples/C10shell \
	examples/C11screen \
	examples/D10tmp \
	examples/D20addnonfree \
	examples/D80no-man-db-rebuild \
	examples/D90chrootmemo \
	examples/F90chrootmemo \
	examples/B90list-missing \
	examples/B91debc \
	examples/execute_installtest.sh \
	examples/execute_paramtest.sh \
	examples/pbuilder-distribution.sh \
	$(NULL)

EXAMPLE_LVMPBUILDER_DATA += \
	examples/lvmpbuilder/README \
	examples/lvmpbuilder/STRATEGY \
	$(NULL)

EXAMPLE_LVMPBUILDER_SCRIPTS += \
	examples/lvmpbuilder/lvmbuilder \
	$(NULL)

EXAMPLE_LVMPBUILDER_LIB_DATA += \
	examples/lvmpbuilder/lib/lvmbuilder-checkparams \
	examples/lvmpbuilder/lib/lvmbuilder-modules \
	examples/lvmpbuilder/lib/lvmbuilder-unimplemented \
	$(NULL)

EXAMPLE_LVMPBUILDER_LIB_SCRIPTS += \
	$(NULL)

EXAMPLE_PBUILDERTEST_DATA += \
	examples/pbuilder-test/README \
	examples/pbuilder-test/002_sample.c \
	$(NULL)

EXAMPLE_PBUILDERTEST_SCRIPTS += \
	examples/pbuilder-test/000_prepinstall \
	examples/pbuilder-test/001_apprun \
	examples/pbuilder-test/002_libfile \
	examples/pbuilder-test/003_makecheck \
	examples/pbuilder-test/004_ldd \
	$(NULL)

EXAMPLE_REBUILD_DATA += \
	examples/rebuild/README \
	$(NULL)

EXAMPLE_REBUILD_SCRIPTS += \
	examples/rebuild/buildall \
	examples/rebuild/getlist \
	$(NULL)

EXAMPLE_WORKAROUND_DATA += \
	$(NULL)

EXAMPLE_WORKAROUND_SCRIPTS += \
	examples/E50-initscripts-2.86.ds1-7.workaround.sh \
	examples/G50-initscripts-2.86.ds1-11-cdebootstrap0.3.9.sh \
	$(NULL)

NOINST_SCRIPTS += \
	debuild.sh \
	testlib.sh \
	test_pbuilder-apt-config \
	test_pbuilder-checkparams \
	test_pbuilder-modules \
	test_pbuilder-satisfydepends-checkparams \
	test_pbuilder-satisfydepends-classic \
	test_pbuilder-satisfydepends-funcs \
	test_testlib.sh \
	$(NULL)

# TODO: check bash_completion.pbuilder

# TODO: check man pages

# TODO: check pbuilderrcs and *.conf

# TODO: check subdirs, more examples etc.

CHECK_SCRIPTS += $(BIN_SCRIPTS) $(PKGLIB_SCRIPTS) $(SBIN_SCRIPTS) $(EXAMPLE_SCRIPTS) $(NOINST_SCRIPTS)

all:

check:
	# syntax check
	$(foreach script,$(CHECK_SCRIPTS),bash -n $(script)$(newline))
	# testsuite
	$(foreach test,$(wildcard ./test_*),$(test)$(newline))

full-check:
	cd testsuite && ./run-test.sh

clean:
	rm -f *.bak *~ TAGS
	rm -f testsuite/testimage
	rm -rf testsuite/testbuild testsuite/testbuild2

TAGS:
	etags pbuilder-* pbuilder

install:
	$(INSTALL_DIRECTORY) $(SYSCONFDIR)/pbuilder
	$(INSTALL_DIRECTORY) $(SBINDIR)
	$(INSTALL_DIRECTORY) $(BINDIR)
	$(INSTALL_DIRECTORY) $(DESTDIR)/etc/bash_completion.d
	$(INSTALL_DIRECTORY) $(PKGLIBDIR)
	$(INSTALL_DIRECTORY) $(PKGDATADIR)
	$(INSTALL_DIRECTORY) $(EXAMPLEDIR)
	$(INSTALL_DIRECTORY) $(EXAMPLE_LVMPBUILDERDIR)
	$(INSTALL_DIRECTORY) $(EXAMPLE_LVMPBUILDER_LIBDIR)
	$(INSTALL_DIRECTORY) $(EXAMPLE_PBUILDERTESTDIR)
	$(INSTALL_DIRECTORY) $(EXAMPLE_REBUILDDIR)
	$(INSTALL_DIRECTORY) $(EXAMPLE_WORKAROUNDDIR)
	$(INSTALL_DIRECTORY) $(DESTDIR)/var/cache/pbuilder/pbuilder-mnt
	$(INSTALL_DIRECTORY) $(DESTDIR)/var/cache/pbuilder/pbuilder-umlresult
	$(foreach script,$(BIN_SCRIPTS),$(INSTALL_EXECUTABLE) $(script) $(BINDIR)$(newline))
	$(foreach script,$(PKGLIB_SCRIPTS),$(INSTALL_EXECUTABLE) $(script) $(PKGLIBDIR)$(newline))
	$(foreach script,$(SBIN_SCRIPTS),$(INSTALL_EXECUTABLE) $(script) $(SBINDIR)$(newline))
	$(foreach file,$(EXAMPLE_DATA),$(INSTALL_FILE) $(file) $(EXAMPLEDIR)$(newline))
	$(foreach script,$(EXAMPLE_SCRIPTS),$(INSTALL_EXECUTABLE) $(script) $(EXAMPLEDIR)$(newline))
	$(foreach file,$(EXAMPLE_REBUILD_DATA),$(INSTALL_FILE) $(file) $(EXAMPLE_REBUILDDIR)$(newline))
	$(foreach script,$(EXAMPLE_REBUILD_SCRIPTS),$(INSTALL_EXECUTABLE) $(script) $(EXAMPLE_REBUILDDIR)$(newline))
	$(foreach file,$(EXAMPLE_PBUILDERTEST_DATA),$(INSTALL_FILE) $(file) $(EXAMPLE_PBUILDERTESTDIR)$(newline))
	$(foreach script,$(EXAMPLE_PBUILDERTEST_SCRIPTS),$(INSTALL_EXECUTABLE) $(script) $(EXAMPLE_PBUILDERTESTDIR)$(newline))
	$(foreach file,$(EXAMPLE_LVMPBUILDER_DATA),$(INSTALL_FILE) $(file) $(EXAMPLE_LVMPBUILDERDIR)$(newline))
	$(foreach script,$(EXAMPLE_LVMPBUILDER_SCRIPTS),$(INSTALL_EXECUTABLE) $(script) $(EXAMPLE_LVMPBUILDERDIR)$(newline))
	$(foreach file,$(EXAMPLE_LVMPBUILDER_LIB_DATA),$(INSTALL_FILE) $(file) $(EXAMPLE_LVMPBUILDER_LIBDIR)$(newline))
	$(foreach script,$(EXAMPLE_LVMPBUILDER_LIB_SCRIPTS),$(INSTALL_EXECUTABLE) $(script) $(EXAMPLE_LVMPBUILDER_LIBDIR)$(newline))
	$(foreach file,$(EXAMPLE_WORKAROUND_DATA),$(INSTALL_FILE) $(file) $(EXAMPLE_WORKAROUNDDIR)$(newline))
	$(foreach script,$(EXAMPLE_WORKAROUND_SCRIPTS),$(INSTALL_EXECUTABLE) $(script) $(EXAMPLE_WORKAROUNDDIR)$(newline))
	# install -aptitude flavour as the default satisfydepends
	ln -sf pbuilder-satisfydepends-aptitude $(PKGLIBDIR)/pbuilder-satisfydepends
	$(INSTALL_FILE) bash_completion.pbuilder $(DESTDIR)/etc/bash_completion.d/pbuilder
	$(INSTALL_FILE) pbuilderrc $(PKGDATADIR)
	$(INSTALL_FILE) pbuilder-uml.conf $(SYSCONFDIR)/pbuilder
	$(INSTALL_FILE) pbuilder-uml.conf $(PKGDATADIR)
	$(MAKE) -C pbuildd $@
	$(MAKE) -C Documentation $@

