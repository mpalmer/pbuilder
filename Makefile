clean:

install:
	install -d $(DESTDIR)/etc
	install -d $(DESTDIR)/usr/sbin
	install -d $(DESTDIR)/usr/lib/pbuilder
	install -m 755 pbuilder-buildpackage $(DESTDIR)/usr/lib/pbuilder/
	install -m 755 pbuilder-createbuildenv $(DESTDIR)/usr/lib/pbuilder/
	install -m 755 pbuilder-updatebuildenv $(DESTDIR)/usr/lib/pbuilder/
	install -m 755 pbuilder-checkparams $(DESTDIR)/usr/lib/pbuilder/
	install -m 755 pbuilder $(DESTDIR)/usr/sbin
	install -m 644 pbuilderrc $(DESTDIR)/etc

