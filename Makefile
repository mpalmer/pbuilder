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

#
# To add new script, add it to here, so that it will be tested. And then add a rule to install: target.
#
SHELLCODES := pbuilder-buildpackage \
	pbuilder-buildpackage-funcs \
	pbuilder-checkparams \
	pbuilder-uml-checkparams \
	pbuilder-createbuildenv \
	pbuilder-loadconfig \
	pbuilder-modules \
	pbuilder-runhooks \
	pbuilder-satisfydepends-classic \
	pbuilder-satisfydepends-gdebi \
	pbuilder-satisfydepends-funcs \
	pbuilder-satisfydepends-checkparams \
	pbuilder-satisfydepends-aptitude \
	pbuilder-satisfydepends-experimental \
	pbuilder-updatebuildenv \
	pbuilder-user-mode-linux \
	pbuilder \
	pdebuild \
	pdebuild-checkparams \
	pdebuild-user-mode-linux \
	pdebuild-internal \
	testlib.sh \
	test_pbuilder-apt-config \
	test_pbuilder-checkparams \
	test_pbuilder-modules \
	test_pbuilder-satisfydepends-checkparams \
	test_pbuilder-satisfydepends-classic \
	test_pbuilder-satisfydepends-funcs \
	test_testlib.sh

all:

define newline


endef

check:
	# syntax check
	$(foreach script,$(SHELLCODES),bash -n $(script)$(newline))
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
	$(INSTALL_EXECUTABLE) pbuilder-buildpackage $(PKGLIBDIR)
	$(INSTALL_EXECUTABLE) pbuilder-buildpackage-funcs $(PKGLIBDIR)
	$(INSTALL_EXECUTABLE) pbuilder-createbuildenv $(PKGLIBDIR)
	$(INSTALL_EXECUTABLE) pbuilder-updatebuildenv $(PKGLIBDIR)
	$(INSTALL_EXECUTABLE) pbuilder-loadconfig $(PKGLIBDIR)
	$(INSTALL_EXECUTABLE) pbuilder-runhooks $(PKGLIBDIR)
	$(INSTALL_EXECUTABLE) pbuilder-checkparams $(PKGLIBDIR)
	$(INSTALL_EXECUTABLE) pdebuild-checkparams $(PKGLIBDIR)
	$(INSTALL_EXECUTABLE) pbuilder-uml-checkparams $(PKGLIBDIR)
	$(INSTALL_EXECUTABLE) pdebuild-uml-checkparams $(PKGLIBDIR)
	$(INSTALL_EXECUTABLE) pbuilder-modules $(PKGLIBDIR)
	$(INSTALL_EXECUTABLE) pbuilder $(SBINDIR)
	$(INSTALL_EXECUTABLE) pdebuild $(BINDIR)
	$(INSTALL_EXECUTABLE) pbuilder-user-mode-linux $(BINDIR)
	$(INSTALL_EXECUTABLE) pdebuild-user-mode-linux $(BINDIR)
	$(INSTALL_EXECUTABLE) debuild-pbuilder $(BINDIR)

	$(INSTALL_EXECUTABLE) pbuilder-satisfydepends-classic $(PKGLIBDIR)
	$(INSTALL_EXECUTABLE) pbuilder-satisfydepends-gdebi $(PKGLIBDIR)
	$(INSTALL_EXECUTABLE) pbuilder-satisfydepends-aptitude $(PKGLIBDIR)
	# install -aptitude flavour as the default satisfydepends
	ln -sf pbuilder-satisfydepends-aptitude $(PKGLIBDIR)/pbuilder-satisfydepends
	$(INSTALL_EXECUTABLE) pbuilder-satisfydepends-experimental $(PKGLIBDIR)
	$(INSTALL_EXECUTABLE) pbuilder-satisfydepends-checkparams $(PKGLIBDIR)
	$(INSTALL_EXECUTABLE) pbuilder-satisfydepends-funcs $(PKGLIBDIR)
	$(INSTALL_EXECUTABLE) pdebuild-internal $(PKGLIBDIR)
	$(INSTALL_FILE) pbuilderrc $(EXAMPLEDIR)
	$(INSTALL_FILE) bash_completion.pbuilder $(DESTDIR)/etc/bash_completion.d/pbuilder
	$(INSTALL_FILE) pbuilderrc $(PKGDATADIR)
	$(INSTALL_FILE) pbuilder-uml.conf $(SYSCONFDIR)/pbuilder
	$(INSTALL_FILE) pbuilder-uml.conf $(PKGDATADIR)
	$(INSTALL_EXECUTABLE) examples/B90lintian $(EXAMPLEDIR)
	$(INSTALL_EXECUTABLE) examples/B91dpkg-i $(EXAMPLEDIR)
	$(INSTALL_EXECUTABLE) examples/B92test-pkg $(EXAMPLEDIR)
	$(INSTALL_EXECUTABLE) examples/C10shell $(EXAMPLEDIR)
	$(INSTALL_EXECUTABLE) examples/C11screen $(EXAMPLEDIR)
	$(INSTALL_EXECUTABLE) examples/D10tmp $(EXAMPLEDIR)
	$(INSTALL_EXECUTABLE) examples/D20addnonfree $(EXAMPLEDIR)
	$(INSTALL_EXECUTABLE) examples/D80no-man-db-rebuild $(EXAMPLEDIR)
	$(INSTALL_EXECUTABLE) examples/D90chrootmemo $(EXAMPLEDIR)
	$(INSTALL_EXECUTABLE) examples/F90chrootmemo $(EXAMPLEDIR)
	$(INSTALL_EXECUTABLE) examples/B90list-missing $(EXAMPLEDIR)
	$(INSTALL_EXECUTABLE) examples/B91debc $(EXAMPLEDIR)
	$(INSTALL_EXECUTABLE) examples/execute_installtest.sh $(EXAMPLEDIR)
	$(INSTALL_EXECUTABLE) examples/execute_paramtest.sh $(EXAMPLEDIR)
	$(INSTALL_EXECUTABLE) examples/pbuilder-distribution.sh $(EXAMPLEDIR)
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

