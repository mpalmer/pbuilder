clean:
	

install:
	install -d $(DESTDIR)/etc
	install -d $(DESTDIR)/usr/sbin
	install -m 755 pbuilder-buildpackage.sh $(DESTDIR)/usr/sbin
	install -m 755 pbuilder-createbuildenv $(DESTDIR)/usr/sbin
	install -m 755 pbuilder-updatebuildenv $(DESTDIR)/usr/sbin
	install -m 755 pbuilder-checkparams $(DESTDIR)/usr/lib/pbuilder/
	install -m 644 pbuilderrc $(DESTDIR)/etc

