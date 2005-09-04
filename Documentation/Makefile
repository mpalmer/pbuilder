# makefile for documentation for pbuilder.

#required packages:
# docbook-xsl
# ldp-docbook-xsl
# xsltproc

all: pbuilder-doc.html

%.html: %.xml pbuilder-doc.xsl
	xsltproc pbuilder-doc.xsl $< > $@.tmp
	mv $@.tmp $@


install: pbuilder-doc.html
	install -d -m 755 -o root -g root $(DESTDIR)/usr/share/doc/pbuilder/
	install -m 644 -o root -g root pbuilder-doc.html $(DESTDIR)/usr/share/doc/pbuilder/

preview: pbuilder-doc.html
	mozilla-firefox -remote "openfile($(PWD)/$<)"

release: pbuilder-doc.html pbuilder-doc.xml pbuilder-doc.css pbuilder-doc.xsl
	scp $^ cvs.alioth.debian.org:/org/alioth.debian.org/chroot/home/groups/pbuilder/htdocs/ 

# for my homepage-publishing.
release-netfort: pbuilder-doc.html pbuilder-doc.xml pbuilder-doc.css pbuilder-doc.xsl
	cp $^ ~/public_html/netfort/software/pbuilder-doc/


.PHONY: preview release-netfort release