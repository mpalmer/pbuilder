INSTALL_DIRECTORY=install -d -m 0755 
INSTALL_FILE=install -m 0644
INSTALL_EXECUTABLE=install -m 0755

clean:
	rm -f *.bak *~ TAGS

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
	$(INSTALL_EXECUTABLE) pbuilder-modules $(DESTDIR)/usr/lib/pbuilder/
	$(INSTALL_EXECUTABLE) pbuilder $(DESTDIR)/usr/sbin
	$(INSTALL_EXECUTABLE) pdebuild $(DESTDIR)/usr/bin
	$(INSTALL_EXECUTABLE) pbuilder-user-mode-linux $(DESTDIR)/usr/bin
	$(INSTALL_EXECUTABLE) debuild-pbuilder $(DESTDIR)/usr/bin
	$(INSTALL_EXECUTABLE) pbuilder-satisfydepends $(DESTDIR)/usr/lib/pbuilder/
	$(INSTALL_FILE) pbuilderrc $(DESTDIR)/etc
	$(INSTALL_FILE) pbuilderrc $(DESTDIR)/usr/share/pbuilder
	$(INSTALL_FILE) pbuilder-uml.conf $(DESTDIR)/etc/pbuilder
	$(INSTALL_FILE) pbuilder-uml.conf $(DESTDIR)/usr/share/pbuilder
	$(INSTALL_EXECUTABLE) examples/B90linda $(DESTDIR)/usr/share/doc/pbuilder/examples
	$(INSTALL_EXECUTABLE) examples/B91dpkg-i $(DESTDIR)/usr/share/doc/pbuilder/examples
	$(INSTALL_EXECUTABLE) examples/C10shell $(DESTDIR)/usr/share/doc/pbuilder/examples
	$(INSTALL_EXECUTABLE) examples/D10tmp $(DESTDIR)/usr/share/doc/pbuilder/examples
	cd pbuildd; make install DESTDIR=$(DESTDIR)
	cd Documentation; make install DESTDIR=$(DESTDIR)

