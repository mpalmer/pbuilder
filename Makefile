clean:
	rm -f *.bak *~ TAGS

TAGS:
	etags pbuilder-* pbuilder

install:
	install -d $(DESTDIR)/etc
	install -d $(DESTDIR)/usr/sbin
	install -d $(DESTDIR)/usr/bin
	install -d $(DESTDIR)/usr/lib/pbuilder
	install -m 755 pbuilder-buildpackage $(DESTDIR)/usr/lib/pbuilder/
	install -m 755 pbuilder-createbuildenv $(DESTDIR)/usr/lib/pbuilder/
	install -m 755 pbuilder-updatebuildenv $(DESTDIR)/usr/lib/pbuilder/
	install -m 755 pbuilder-runhooks $(DESTDIR)/usr/lib/pbuilder/
	install -m 755 pbuilder-checkparams $(DESTDIR)/usr/lib/pbuilder/
	install -m 755 pbuilder-modules $(DESTDIR)/usr/lib/pbuilder/
	install -m 755 pbuilder $(DESTDIR)/usr/sbin
	install -m 755 pdebuild $(DESTDIR)/usr/bin
	install -m 644 pbuilderrc $(DESTDIR)/etc

