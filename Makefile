INSTALL_DIRECTORY=install -d -m 0755 
INSTALL_FILE=install -m 0644
INSTALL_EXECUTABLE=install -m 0755

clean:
	rm -f *.bak *~ TAGS

TAGS:
	etags pbuilder-* pbuilder

install:
	$(INSTALL_DIRECTORY) $(DESTDIR)/etc
	$(INSTALL_DIRECTORY) $(DESTDIR)/usr/sbin
	$(INSTALL_DIRECTORY) $(DESTDIR)/usr/bin
	$(INSTALL_DIRECTORY) $(DESTDIR)/usr/lib/pbuilder
	$(INSTALL_DIRECTORY) $(DESTDIR)/usr/share/pbuilder
	$(INSTALL_EXECUTABLE) pbuilder-buildpackage $(DESTDIR)/usr/lib/pbuilder/
	$(INSTALL_EXECUTABLE) pbuilder-createbuildenv $(DESTDIR)/usr/lib/pbuilder/
	$(INSTALL_EXECUTABLE) pbuilder-updatebuildenv $(DESTDIR)/usr/lib/pbuilder/
	$(INSTALL_EXECUTABLE) pbuilder-runhooks $(DESTDIR)/usr/lib/pbuilder/
	$(INSTALL_EXECUTABLE) pbuilder-checkparams $(DESTDIR)/usr/lib/pbuilder/
	$(INSTALL_EXECUTABLE) pbuilder-modules $(DESTDIR)/usr/lib/pbuilder/
	$(INSTALL_EXECUTABLE) pbuilder $(DESTDIR)/usr/sbin
	$(INSTALL_EXECUTABLE) pdebuild $(DESTDIR)/usr/bin
	$(INSTALL_FILE) pbuilderrc $(DESTDIR)/etc
	$(INSTALL_FILE) pbuilderrc $(DESTDIR)/usr/share/pbuilder

