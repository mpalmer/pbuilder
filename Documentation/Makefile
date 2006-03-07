# makefile for documentation for pbuilder.

#required packages:
# docbook-xsl
# ldp-docbook-xsl
# xsltproc

all: pbuilder-doc.html

%.html: %.xml pbuilder-doc.xsl
	xsltproc pbuilder-doc.xsl $< > $@.tmp
	mv $@.tmp $@

%.tex: %.xml debian-latex.xsl
	## requires db2latex-xsl and xsltproc package.
	xsltproc --nonet --novalid --xinclude debian-latex.xsl $< > $@.tmp
	mv $@.tmp $@

%.pdf: %.tex
	pdflatex $<
	pdflatex $<

install: pbuilder-doc.html
	install -d -m 755 -o root -g root $(DESTDIR)/usr/share/doc/pbuilder/
	install -m 644 -o root -g root pbuilder-doc.html $(DESTDIR)/usr/share/doc/pbuilder/

preview: pbuilder-doc.html
	mozilla-firefox -remote "openfile($(PWD)/$<)"

release: pbuilder-doc.html pbuilder-doc.xml pbuilder-doc.css pbuilder-doc.xsl pbuilder-doc.pdf
	scp $^ cvs.alioth.debian.org:/org/alioth.debian.org/chroot/home/groups/pbuilder/htdocs/ 
	$(MAKE) release-netfort

# for my homepage-publishing.
release-netfort: pbuilder-doc.html pbuilder-doc.xml pbuilder-doc.css pbuilder-doc.xsl pbuilder-doc.pdf
	cp $^ ~/public_html/netfort/software/pbuilder-doc/

clean: 
	-rm pbuilder-doc.pdf pbuilder-doc.glo pbuilder-doc.idx pbuilder-doc.log pbuilder-doc.out


.PHONY: preview release-netfort release clean
