# makefile for documentation for pbuilder.

#required packages:
# docbook-xsl
# ldp-docbook-xsl
# xsltproc

all: pbuilder-doc.html

%.html: %.xml
	xsltproc /usr/share/sgml/docbook/stylesheet/xsl/ldp/ldp-html.xsl $< > $@

# for my homepage-publishing.
release-netfort: pbuilder-doc.html pbuilder-doc.xml
	cp $^ ~/public_html/netfort/software/pbuilder-doc/


install: pbuilder-doc.html
	install -d -m 755 -o root -g root $(DESTDIR)/usr/share/doc/pbuilder/
	install -m 644 -o root -g root pbuilder-doc.html $(DESTDIR)/usr/share/doc/pbuilder/
