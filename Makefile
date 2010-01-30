INSTALL = install
INSTALL_DIRECTORY = $(INSTALL) -d -m 0755
INSTALL_FILE = $(INSTALL) -m 0644
INSTALL_EXECUTABLE = $(INSTALL) -m 0755

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
	$(INSTALL_DIRECTORY) $(DESTDIR)/etc/pbuilder
	$(INSTALL_DIRECTORY) $(DESTDIR)/etc/bash_completion.d
	$(INSTALL_DIRECTORY) $(DESTDIR)/usr/sbin
	$(INSTALL_DIRECTORY) $(DESTDIR)/usr/bin
	$(INSTALL_DIRECTORY) $(DESTDIR)/usr/lib/pbuilder
	$(INSTALL_DIRECTORY) $(DESTDIR)/usr/share/pbuilder
	$(INSTALL_DIRECTORY) $(DESTDIR)/usr/share/doc/pbuilder/examples
	$(INSTALL_DIRECTORY) $(DESTDIR)/usr/share/doc/pbuilder/examples/rebuild
	$(INSTALL_DIRECTORY) $(DESTDIR)/usr/share/doc/pbuilder/examples/pbuilder-test
	$(INSTALL_DIRECTORY) $(DESTDIR)/usr/share/doc/pbuilder/examples/lvmpbuilder
	$(INSTALL_DIRECTORY) $(DESTDIR)/usr/share/doc/pbuilder/examples/lvmpbuilder/lib
	$(INSTALL_DIRECTORY) $(DESTDIR)/var/cache/pbuilder/pbuilder-mnt
	$(INSTALL_DIRECTORY) $(DESTDIR)/var/cache/pbuilder/pbuilder-umlresult
	$(INSTALL_EXECUTABLE) pbuilder-buildpackage $(DESTDIR)/usr/lib/pbuilder/
	$(INSTALL_EXECUTABLE) pbuilder-buildpackage-funcs $(DESTDIR)/usr/lib/pbuilder/
	$(INSTALL_EXECUTABLE) pbuilder-createbuildenv $(DESTDIR)/usr/lib/pbuilder/
	$(INSTALL_EXECUTABLE) pbuilder-updatebuildenv $(DESTDIR)/usr/lib/pbuilder/
	$(INSTALL_EXECUTABLE) pbuilder-loadconfig $(DESTDIR)/usr/lib/pbuilder/
	$(INSTALL_EXECUTABLE) pbuilder-runhooks $(DESTDIR)/usr/lib/pbuilder/
	$(INSTALL_EXECUTABLE) pbuilder-checkparams $(DESTDIR)/usr/lib/pbuilder/
	$(INSTALL_EXECUTABLE) pdebuild-checkparams $(DESTDIR)/usr/lib/pbuilder/
	$(INSTALL_EXECUTABLE) pbuilder-uml-checkparams $(DESTDIR)/usr/lib/pbuilder/
	$(INSTALL_EXECUTABLE) pdebuild-uml-checkparams $(DESTDIR)/usr/lib/pbuilder/
	$(INSTALL_EXECUTABLE) pbuilder-modules $(DESTDIR)/usr/lib/pbuilder/
	$(INSTALL_EXECUTABLE) pbuilder $(DESTDIR)/usr/sbin
	$(INSTALL_EXECUTABLE) pdebuild $(DESTDIR)/usr/bin
	$(INSTALL_EXECUTABLE) pbuilder-user-mode-linux $(DESTDIR)/usr/bin
	$(INSTALL_EXECUTABLE) pdebuild-user-mode-linux $(DESTDIR)/usr/bin
	$(INSTALL_EXECUTABLE) debuild-pbuilder $(DESTDIR)/usr/bin

	$(INSTALL_EXECUTABLE) pbuilder-satisfydepends-classic $(DESTDIR)/usr/lib/pbuilder/
	$(INSTALL_EXECUTABLE) pbuilder-satisfydepends-gdebi $(DESTDIR)/usr/lib/pbuilder/
	$(INSTALL_EXECUTABLE) pbuilder-satisfydepends-aptitude $(DESTDIR)/usr/lib/pbuilder/
	# install -aptitude flavour as the default satisfydepends
	ln -sf pbuilder-satisfydepends-aptitude $(DESTDIR)/usr/lib/pbuilder/pbuilder-satisfydepends
	$(INSTALL_EXECUTABLE) pbuilder-satisfydepends-experimental $(DESTDIR)/usr/lib/pbuilder/
	$(INSTALL_EXECUTABLE) pbuilder-satisfydepends-checkparams $(DESTDIR)/usr/lib/pbuilder/
	$(INSTALL_EXECUTABLE) pbuilder-satisfydepends-funcs $(DESTDIR)/usr/lib/pbuilder/
	$(INSTALL_EXECUTABLE) pdebuild-internal $(DESTDIR)/usr/lib/pbuilder/
	$(INSTALL_FILE) pbuilderrc $(DESTDIR)/usr/share/doc/pbuilder/examples
	$(INSTALL_FILE) bash_completion.pbuilder $(DESTDIR)/etc/bash_completion.d/pbuilder
	$(INSTALL_FILE) pbuilderrc $(DESTDIR)/usr/share/pbuilder
	$(INSTALL_FILE) pbuilder-uml.conf $(DESTDIR)/etc/pbuilder
	$(INSTALL_FILE) pbuilder-uml.conf $(DESTDIR)/usr/share/pbuilder
	$(INSTALL_EXECUTABLE) examples/B90lintian $(DESTDIR)/usr/share/doc/pbuilder/examples
	$(INSTALL_EXECUTABLE) examples/B91dpkg-i $(DESTDIR)/usr/share/doc/pbuilder/examples
	$(INSTALL_EXECUTABLE) examples/B92test-pkg $(DESTDIR)/usr/share/doc/pbuilder/examples
	$(INSTALL_EXECUTABLE) examples/C10shell $(DESTDIR)/usr/share/doc/pbuilder/examples
	$(INSTALL_EXECUTABLE) examples/C11screen $(DESTDIR)/usr/share/doc/pbuilder/examples
	$(INSTALL_EXECUTABLE) examples/D10tmp $(DESTDIR)/usr/share/doc/pbuilder/examples
	$(INSTALL_EXECUTABLE) examples/D20addnonfree $(DESTDIR)/usr/share/doc/pbuilder/examples
	$(INSTALL_EXECUTABLE) examples/D80no-man-db-rebuild $(DESTDIR)/usr/share/doc/pbuilder/examples
	$(INSTALL_EXECUTABLE) examples/D90chrootmemo $(DESTDIR)/usr/share/doc/pbuilder/examples
	$(INSTALL_EXECUTABLE) examples/F90chrootmemo $(DESTDIR)/usr/share/doc/pbuilder/examples
	$(INSTALL_EXECUTABLE) examples/B90list-missing $(DESTDIR)/usr/share/doc/pbuilder/examples
	$(INSTALL_EXECUTABLE) examples/B91debc $(DESTDIR)/usr/share/doc/pbuilder/examples
	$(INSTALL_EXECUTABLE) examples/execute_installtest.sh $(DESTDIR)/usr/share/doc/pbuilder/examples
	$(INSTALL_EXECUTABLE) examples/execute_paramtest.sh $(DESTDIR)/usr/share/doc/pbuilder/examples
	$(INSTALL_EXECUTABLE) examples/pbuilder-distribution.sh $(DESTDIR)/usr/share/doc/pbuilder/examples
	$(INSTALL_EXECUTABLE) examples/rebuild/buildall $(DESTDIR)/usr/share/doc/pbuilder/examples/rebuild
	$(INSTALL_EXECUTABLE) examples/rebuild/getlist $(DESTDIR)/usr/share/doc/pbuilder/examples/rebuild
	$(INSTALL_FILE) examples/rebuild/README $(DESTDIR)/usr/share/doc/pbuilder/examples/rebuild
	$(INSTALL_FILE) examples/pbuilder-test/README $(DESTDIR)/usr/share/doc/pbuilder/examples/pbuilder-test
	$(INSTALL_EXECUTABLE) examples/pbuilder-test/000_prepinstall $(DESTDIR)/usr/share/doc/pbuilder/examples/pbuilder-test
	$(INSTALL_EXECUTABLE) examples/pbuilder-test/001_apprun $(DESTDIR)/usr/share/doc/pbuilder/examples/pbuilder-test
	$(INSTALL_EXECUTABLE) examples/pbuilder-test/002_libfile $(DESTDIR)/usr/share/doc/pbuilder/examples/pbuilder-test
	$(INSTALL_FILE) examples/pbuilder-test/002_sample.c $(DESTDIR)/usr/share/doc/pbuilder/examples/pbuilder-test
	$(INSTALL_EXECUTABLE) examples/pbuilder-test/003_makecheck $(DESTDIR)/usr/share/doc/pbuilder/examples/pbuilder-test
	$(INSTALL_EXECUTABLE) examples/pbuilder-test/004_ldd $(DESTDIR)/usr/share/doc/pbuilder/examples/pbuilder-test

	$(INSTALL_FILE) examples/lvmpbuilder/README $(DESTDIR)/usr/share/doc/pbuilder/examples/lvmpbuilder
	$(INSTALL_FILE) examples/lvmpbuilder/STRATEGY $(DESTDIR)/usr/share/doc/pbuilder/examples/lvmpbuilder
	$(INSTALL_EXECUTABLE) examples/lvmpbuilder/lvmbuilder $(DESTDIR)/usr/share/doc/pbuilder/examples/lvmpbuilder
	$(INSTALL_FILE) examples/lvmpbuilder/lib/lvmbuilder-checkparams $(DESTDIR)/usr/share/doc/pbuilder/examples/lvmpbuilder/lib
	$(INSTALL_FILE) examples/lvmpbuilder/lib/lvmbuilder-modules $(DESTDIR)/usr/share/doc/pbuilder/examples/lvmpbuilder/lib
	$(INSTALL_FILE) examples/lvmpbuilder/lib/lvmbuilder-unimplemented $(DESTDIR)/usr/share/doc/pbuilder/examples/lvmpbuilder/lib

	# install workaround for initscripts -- 2005-12-21
	$(INSTALL_DIRECTORY) $(DESTDIR)/usr/share/doc/pbuilder/examples/workaround
	$(INSTALL_EXECUTABLE) examples/E50-initscripts-2.86.ds1-7.workaround.sh $(DESTDIR)/usr/share/doc/pbuilder/examples/workaround
	$(INSTALL_EXECUTABLE) examples/G50-initscripts-2.86.ds1-11-cdebootstrap0.3.9.sh $(DESTDIR)/usr/share/doc/pbuilder/examples/workaround

	$(MAKE) -C pbuildd $@
	$(MAKE) -C Documentation $@

