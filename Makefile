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
	$(INSTALL_DIRECTORY) $(EXAMPLEDIR)/rebuild
	$(INSTALL_DIRECTORY) $(EXAMPLEDIR)/pbuilder-test
	$(INSTALL_DIRECTORY) $(EXAMPLEDIR)/lvmpbuilder
	$(INSTALL_DIRECTORY) $(EXAMPLEDIR)/lvmpbuilder/lib
	$(INSTALL_DIRECTORY) $(DESTDIR)/var/cache/pbuilder/pbuilder-mnt
	$(INSTALL_DIRECTORY) $(DESTDIR)/var/cache/pbuilder/pbuilder-umlresult
	$(foreach script,$(BIN_SCRIPTS),$(INSTALL_EXECUTABLE) $(script) $(BINDIR)$(newline))
	$(foreach script,$(PKGLIB_SCRIPTS),$(INSTALL_EXECUTABLE) $(script) $(PKGLIBDIR)$(newline))
	$(foreach script,$(SBIN_SCRIPTS),$(INSTALL_EXECUTABLE) $(script) $(SBINDIR)$(newline))
	$(foreach script,$(EXAMPLE_SCRIPTS),$(INSTALL_EXECUTABLE) $(script) $(EXAMPLEDIR)$(newline))
	# install -aptitude flavour as the default satisfydepends
	ln -sf pbuilder-satisfydepends-aptitude $(PKGLIBDIR)/pbuilder-satisfydepends
	$(INSTALL_FILE) pbuilderrc $(EXAMPLEDIR)
	$(INSTALL_FILE) bash_completion.pbuilder $(DESTDIR)/etc/bash_completion.d/pbuilder
	$(INSTALL_FILE) pbuilderrc $(PKGDATADIR)
	$(INSTALL_FILE) pbuilder-uml.conf $(SYSCONFDIR)/pbuilder
	$(INSTALL_FILE) pbuilder-uml.conf $(PKGDATADIR)
	$(INSTALL_EXECUTABLE) examples/rebuild/buildall $(EXAMPLEDIR)/rebuild
	$(INSTALL_EXECUTABLE) examples/rebuild/getlist $(EXAMPLEDIR)/rebuild
	$(INSTALL_FILE) examples/rebuild/README $(EXAMPLEDIR)/rebuild
	$(INSTALL_FILE) examples/pbuilder-test/README $(EXAMPLEDIR)/pbuilder-test
	$(INSTALL_EXECUTABLE) examples/pbuilder-test/000_prepinstall $(EXAMPLEDIR)/pbuilder-test
	$(INSTALL_EXECUTABLE) examples/pbuilder-test/001_apprun $(EXAMPLEDIR)/pbuilder-test
	$(INSTALL_EXECUTABLE) examples/pbuilder-test/002_libfile $(EXAMPLEDIR)/pbuilder-test
	$(INSTALL_FILE) examples/pbuilder-test/002_sample.c $(EXAMPLEDIR)/pbuilder-test
	$(INSTALL_EXECUTABLE) examples/pbuilder-test/003_makecheck $(EXAMPLEDIR)/pbuilder-test
	$(INSTALL_EXECUTABLE) examples/pbuilder-test/004_ldd $(EXAMPLEDIR)/pbuilder-test

	$(INSTALL_FILE) examples/lvmpbuilder/README $(EXAMPLEDIR)/lvmpbuilder
	$(INSTALL_FILE) examples/lvmpbuilder/STRATEGY $(EXAMPLEDIR)/lvmpbuilder
	$(INSTALL_EXECUTABLE) examples/lvmpbuilder/lvmbuilder $(EXAMPLEDIR)/lvmpbuilder
	$(INSTALL_FILE) examples/lvmpbuilder/lib/lvmbuilder-checkparams $(EXAMPLEDIR)/lvmpbuilder/lib
	$(INSTALL_FILE) examples/lvmpbuilder/lib/lvmbuilder-modules $(EXAMPLEDIR)/lvmpbuilder/lib
	$(INSTALL_FILE) examples/lvmpbuilder/lib/lvmbuilder-unimplemented $(EXAMPLEDIR)/lvmpbuilder/lib

	# install workaround for initscripts -- 2005-12-21
	$(INSTALL_DIRECTORY) $(EXAMPLEDIR)/workaround
	$(INSTALL_EXECUTABLE) examples/E50-initscripts-2.86.ds1-7.workaround.sh $(EXAMPLEDIR)/workaround
	$(INSTALL_EXECUTABLE) examples/G50-initscripts-2.86.ds1-11-cdebootstrap0.3.9.sh $(EXAMPLEDIR)/workaround

	$(MAKE) -C pbuildd $@
	$(MAKE) -C Documentation $@

