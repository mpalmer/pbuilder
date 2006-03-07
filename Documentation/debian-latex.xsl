<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:import href="http://db2latex.sourceforge.net/xsl/docbook.xsl"/>
  <!-- xsl:import
    href="/usr/share/sgml/docbook/stylesheet/xsl/db2latex/latex/docbook.xsl"/ -->

  <xsl:param name="admon.graphics.path">/usr/share/xml/docbook/stylesheet/db2latex/latex/figures</xsl:param>
  <xsl:param name="latex.document.font">default</xsl:param>
  <xsl:param name="latex.documentclass.article">10pt,a4paper,onecolumn,twoside</xsl:param>
  <xsl:param name="latex.graphics.formats">PDF</xsl:param>
  <xsl:param name="latex.hyperref.param.dvips">1</xsl:param>
  <xsl:param name="latex.inputenc">latin1</xsl:param> <!-- this doesn't look correct, but anyway -->
  <xsl:param name="latex.pdf.support">1</xsl:param>
  <xsl:param name="latex.use.fancybox">1</xsl:param>
  <xsl:param name="latex.use.fancyhdr">1</xsl:param>
  <xsl:param name="latex.use.fancyvrb">1</xsl:param>
  <xsl:param name="latex.use.hyperref">1</xsl:param>
  <xsl:param name="latex.use.parskip">1</xsl:param>
  <xsl:param name="latex.use.tabularx">1</xsl:param>

  <xsl:variable name="latex.hyperref.param.pdftex">
    pdfauthor={<xsl:value-of
      select="/book/bookinfo/editor/firstname"/> <xsl:value-of
      select="/book/bookinfo/editor/surname"/>},
    pdfpagemode=UseNone,
    pdftitle={<xsl:value-of select="/book/bookinfo/title"/>},
    pdfpagelabels,
    pdfsubject={<xsl:value-of select="/book/bookinfo/subtitle"/>},
    pdfkeywords={<xsl:call-template name="keyword-list"/>},
    pdfcreator={DocBook/XML db2latex-xsl},
    pdfstartview=FitH
  </xsl:variable>

  <xsl:variable name="latex.book.preamble.post">
    <xsl:text>
      \pagestyle{fancy}
      \rhead[\leftmark]{}
      \lhead[]{\rightmark}
      \sloppy
    </xsl:text>    
  </xsl:variable>

  <xsl:template name="keyword-list">
    <xsl:for-each select="/book/bookinfo/keywordset/keyword">
      <xsl:value-of select="."/>
      <xsl:if test="position()!=last()">
        <xsl:text>, </xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- I'm probably missing something here, I don't know why -->
  <xsl:template name="debian">
    \begin{center}
    \includegraphics[height=2cm]{openlogo-nd.pdf} \\
    \texttt{http://www.debian.org/}
    \end{center}
  </xsl:template>

  <xsl:template match="book/title">
  </xsl:template>

  <xsl:template match="book/bookinfo"
		mode="standalone.book">
    <xsl:call-template name="debian"/>
    <xsl:apply-templates select="keywordset" />
    <xsl:apply-templates select="legalnotice" />
    <xsl:apply-templates select="abstract"/>
  </xsl:template>
</xsl:stylesheet>
