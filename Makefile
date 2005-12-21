INSTALL_DIRECTORY=install -d -m 0755 
INSTALL_FILE=install -m 0644
INSTALL_EXECUTABLE=install -m 0755


#
# To add new script, add it to here, so that it will be tested. And then add a rule to install: target.
#
SHELLCODES=pbuilder-buildpackage \
	pbuilder-buildpackage-funcs \
	pbuilder-checkparams \
	pbuilder-uml-checkparams \
	pbuilder-createbuildenv \
	pbuilder-loadconfig \
	pbuilder-modules \
	pbuilder-runhooks \
	pbuilder-satisfydepends \
	pbuilder-updatebuildenv \
	pbuilder-user-mode-linux \
	pbuilder \
	pdebuild \
	pdebuild-checkparams \
	pdebuild-user-mode-linux \
	pdebuild-internal

check:
	set -e;
	for A in $(SHELLCODES); do \
		bash -n $$A; \
		echo $$A; \
	done

full-check: 
	set -e; \
	cd testsuite; \
	./run-test.sh 

clean:
	rm -f *.bak *~ TAGS
	rm -f testsuite/testimage
	rm -rf testsuite/testbuild testsuite/testbuild2

TAGS:
	etags pbuilder-* pbuilder

install:
	$(INSTALL_DIRECTORY) $(DESTDIR)/etc
	$(INSTALL_DIRECTORY) $(DESTDIR)/etc/pbuilder
	$(INSTALL_DIRECTORY) $(DESTDIR)/usr/sbin
	$(INSTALL_DIRECTORY) $(DESTDIR)/usr/bin
	$(INSTALL_DIRECTORY) $(DESTDIR)/usr/lib/pbuilder
	$(INSTALL_DIRECTORY) $(DESTDIR)/usr/share/pbuilder
	$(INSTALL_DIRECTORY) $(DESTDIR)/usr/share/doc/pbuilder/examples
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
	$(INSTALL_EXECUTABLE) pbuilder-satisfydepends $(DESTDIR)/usr/lib/pbuilder/
	$(INSTALL_EXECUTABLE) pdebuild-internal $(DESTDIR)/usr/lib/pbuilder/
	$(INSTALL_FILE) pbuilderrc $(DESTDIR)/etc
	$(INSTALL_FILE) pbuilderrc $(DESTDIR)/usr/share/pbuilder
	$(INSTALL_FILE) pbuilder-uml.conf $(DESTDIR)/etc/pbuilder
	$(INSTALL_FILE) pbuilder-uml.conf $(DESTDIR)/usr/share/pbuilder
	$(INSTALL_EXECUTABLE) examples/B90linda $(DESTDIR)/usr/share/doc/pbuilder/examples
	$(INSTALL_EXECUTABLE) examples/B91dpkg-i $(DESTDIR)/usr/share/doc/pbuilder/examples
	$(INSTALL_EXECUTABLE) examples/B92test-pkg $(DESTDIR)/usr/share/doc/pbuilder/examples
	$(INSTALL_EXECUTABLE) examples/C10shell $(DESTDIR)/usr/share/doc/pbuilder/examples
	$(INSTALL_EXECUTABLE) examples/D10tmp $(DESTDIR)/usr/share/doc/pbuilder/examples
	$(INSTALL_EXECUTABLE) examples/D90chrootmemo $(DESTDIR)/usr/share/doc/pbuilder/examples
	$(INSTALL_EXECUTABLE) examples/F90chrootmemo $(DESTDIR)/usr/share/doc/pbuilder/examples
	$(INSTALL_EXECUTABLE) examples/execute_installtest.sh $(DESTDIR)/usr/share/doc/pbuilder/examples
	$(INSTALL_EXECUTABLE) examples/execute_paramtest.sh $(DESTDIR)/usr/share/doc/pbuilder/examples
	$(INSTALL_EXECUTABLE) examples/pbuilder-distribution.sh $(DESTDIR)/usr/share/doc/pbuilder/examples

	# install workaround for initscripts -- 2005-12-21
	$(INSTALL_DIRECTORY) $(DESTDIR)/usr/share/doc/pbuilder/examples/344089
	$(INSTALL_EXECUTABLE) examples/E50-initscripts-2.86.ds1-7.workaround.sh $(DESTDIR)/usr/share/doc/pbuilder/examples/344089



	cd pbuildd; make install DESTDIR=$(DESTDIR)
	cd Documentation; make install DESTDIR=$(DESTDIR)

