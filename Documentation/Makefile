# makefile for documentation for pbuilder.

#required packages:
# docbook-xsl
# ldp-docbook-xsl
# xsltproc
# po4a
# dblatex

# the main XML file which is source to all documents
MASTERXML=pbuilder-doc.xml
HTMLDOCS= pbuilder-doc.html pbuilder-doc.ja.html pbuilder-doc.fr.html

all: pbuilder-doc.html pbuilder-doc.ja.html pbuilder-doc.fr.html

%.html: %.xml pbuilder-doc.xsl
	xsltproc pbuilder-doc.xsl $< > $@.tmp
	mv $@.tmp $@

pbuilder-doc.%.xml: pbuilder-doc.%.po
	po4a-translate -f docbook -m $(MASTERXML) -p $< -l $@ -k 1

pbuilder-doc.%.po: $(MASTERXML)
	po4a-updatepo -f docbook -m $< -p $@ 

%.pdf: %.xml
	# requires dblatex package.
	dblatex $<

install: $(HTMLDOCS) pbuilder-doc.pdf
	install -d -m 755 -o root -g root $(DESTDIR)/usr/share/doc/pbuilder/
	install -m 644 -o root -g root $(HTMLDOCS) $(DESTDIR)/usr/share/doc/pbuilder/
	install -m 644 -o root -g root pbuilder-doc.pdf $(DESTDIR)/usr/share/doc/pbuilder/

preview: pbuilder-doc.html
	mozilla-firefox -remote "openfile($(PWD)/$<)"

release: pbuilder-doc.html pbuilder-doc.xml pbuilder-doc.css pbuilder-doc.xsl pbuilder-doc.pdf
	scp $^ cvs.alioth.debian.org:/org/alioth.debian.org/chroot/home/groups/pbuilder/htdocs/ 
	$(MAKE) release-netfort

# for my homepage-publishing.
release-netfort: pbuilder-doc.html pbuilder-doc.xml pbuilder-doc.css pbuilder-doc.xsl pbuilder-doc.pdf
	cp $^ ~/public_html/netfort/software/pbuilder-doc/

clean: 
	rm -f pbuilder-doc.pdf pbuilder-doc.glo pbuilder-doc.idx pbuilder-doc.log pbuilder-doc.out \
		pbuilder-doc.aux pbuilder-doc.html.tmp

.PHONY: preview release-netfort release clean
