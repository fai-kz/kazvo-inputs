<!-- -*- indent-offset: 8; -*- -->
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:ri="http://www.ivoa.net/xml/RegistryInterface/v1.0"
    xmlns:vr="http://www.ivoa.net/xml/VOResource/v1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    version="1.0">

    <!-- ############################################## Global behaviour -->

    <xsl:output method="xml" indent="yes"/>

    <!-- Don't spill the content of unknown elements. -->
    <xsl:template match="text()"/>

    <xsl:param name="favicon">/favicon.png</xsl:param>

    <!-- XXX TODO: we'll need to be more careful when there are
       more altIdentifier schemes.  Promise. -->
    <xsl:variable name="doi" select="//ri:Resource/altIdentifier"/>

    <xsl:template match="ri:Resource">
        <html>
        <head>
                <meta http-equiv="content-type" content="text/html;charset=utf-8"/>
                <title><xsl:value-of select="title"/></title>

                <link rel="icon">
                    <xsl:attribute name="href"
                        ><xsl:value-of select="$favicon"
                    /></xsl:attribute>
                </link>
                <link rel="stylesheet" type="text/css"
                    href="/rr/q/lp/static/landingpage.css"/>
        </head>
        <body>
                <h1 id="doctitle"><xsl:apply-templates select="title"/>
                  <span class="doctype"><xsl:call-template name="doctype"/></span></h1>

        <div class="infobox" id="overview">
            <dl id="idbox">
                <dt>Authors</dt>
                  <dd id="authors"><ol class="inline"><xsl:apply-templates select="curation/creator"/>
                  <dl class="publisher inline"><xsl:apply-templates select="curation/publisher"/></dl>
                  </ol></dd>

                <dt>Abstract</dt>
                  <dd id="abstract"><xsl:apply-templates select="content/description"/></dd>
                <dt>Keywords</dt>
                  <dd id="keywords"><ol class="inline"><xsl:apply-templates select="content/subject"/></ol></dd>
                <xsl:apply-templates select="content/source"/>
                <xsl:apply-templates select="content/referenceURL"/>
                <xsl:apply-templates select="identifier"/>
                <xsl:apply-templates select="altIdentifier"/>
            </dl>
        </div>

        <div class="infobox" id="metadata">
            <h2>Access<!-- Use <span class="joiner">+</span> cite--></h2>
            <dl>
                <xsl:apply-templates select="capability"/>
            </dl>
        </div>

        <div class="infobox sidebyside" id="dates">
            <h2>History</h2>
            <dl>
                    <dt><span class="datestamp"><xsl:value-of select="//ri:Resource/@created"/></span></dt>
                    <dd>Resource record created</dd>
                    <xsl:apply-templates select="curation/date">
                        <xsl:sort data-type="text"
                            select="."
                            order="ascending"/>
                    </xsl:apply-templates>
            </dl>

            </div>

        <div class="infobox sidebyside" id="contact">
            <h2>Contact</h2>
            <dl>
                <xsl:apply-templates select="curation/contact"/>
            </dl>
        </div>

        </body>
        </html>
    </xsl:template>

    <xsl:template match="title">
        <span class="dc:title"><xsl:value-of select="."/></span>
    </xsl:template>

    <xsl:template match="identifier">
        <dt>IVOA Identifier <span class="protocol">IVOID</span></dt>
        <dd><span class="identifier"
            ><a>
              <xsl:attribute name="href"
                >https://dachs.fai.kz/rr/q/nmah/custom/<xsl:value-of select="."/></xsl:attribute>
                <xsl:value-of select="."/></a></span></dd>
    </xsl:template>

    <xsl:template match="altIdentifier">
        <xsl:if test="starts-with(., 'doi:')">
            <dt>Document Object Identifer <span class="protocol">DOI</span></dt>
            <dd><span class="dc:identifier"><a>
              <xsl:attribute name="href"
                >https://doi.org/<xsl:value-of select="substring-after(., 'doi:')"/></xsl:attribute>
            <xsl:value-of select="."/>
                </a></span></dd>
        </xsl:if>
    </xsl:template>

    <xsl:template match="name">
        <li class="name"><xsl:value-of select="."/></li>
    </xsl:template>

    <xsl:template match="creator">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="subject">
        <li><xsl:value-of select="."/></li>
    </xsl:template>

    <xsl:template match="content/description">
        <!-- assume that material is pre-formatted if it contains lfs -->
        <xsl:choose>
            <xsl:when test="contains(., '&#x0a;')">
                <pre class="abstract"><xsl:value-of select="text()"/></pre>
            </xsl:when>
            <xsl:otherwise>
                <p class="abstract"><xsl:value-of select="text()"/></p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="contact/name">
        <dt>Name</dt><dd><xsl:value-of select="."/></dd>
    </xsl:template>

    <xsl:template match="email">
        <dt>E-Mail</dt><dd id="email"><xsl:value-of select="."/></dd>
    </xsl:template>

    <xsl:template match="address">
        <dt>Postal Address</dt><dd><address><xsl:value-of select="."/></address></dd>
    </xsl:template>

    <xsl:template match="telephone">
        <dt>Telephone</dt><dd><xsl:value-of select="."/></dd>
    </xsl:template>

    <xsl:template match="referenceURL">
            <dt class="browsable">See also <span class="protocol">HTML</span></dt>
            <dd><a>
              <xsl:attribute name="href">
                  <xsl:value-of
                      select="."/>
              </xsl:attribute>
              <xsl:value-of select="."/>
        </a></dd>
    </xsl:template>

    <xsl:template match="source[@format='bibcode']">
        <dt class="browsable">Bibliographic source <span class="protocol">Bibcode</span></dt>
        <dd><a>
              <xsl:attribute name="href"
                  >https://adsabs.harvard.edu/abs/<xsl:value-of
                      select="."/>
              </xsl:attribute>
              <xsl:value-of select="."/>
        </a></dd>
    </xsl:template>

    <xsl:template match="source[starts-with(., 'http')]">
        <dt class="browsable">Bibliographic source <span class="protocol">HTTP</span></dt>
        <dd><a>
              <xsl:attribute name="href"
                  ><xsl:value-of select="."/>
              </xsl:attribute>
              <xsl:value-of select="."/>
        </a></dd>
    </xsl:template>

    <xsl:template match="source">
        <dt>Bibliographic source</dt>
        <dd><xsl:value-of select="."/></dd>
    </xsl:template>

    <xsl:template match="publisher">
        <dt>Published by</dt>
        <dd><a href="#contact"><xsl:value-of select="."/></a></dd>
    </xsl:template>

    <xsl:template match="publisher-simple">
        <xsl:value-of select="."/>
    </xsl:template>

    <xsl:template match="version">
        <dt>Version</dt>
        <dd><xsl:value-of select="."/></dd>
    </xsl:template>

    <xsl:template match="date">
        <dt><span class="datestamp"><xsl:value-of select="text()"/></span></dt>
        <dd><xsl:value-of select="@role"/></dd>
    </xsl:template>

    <xsl:template name="doctype">
        <xsl:choose>
            <xsl:when test="/*/@xsi:type='vstd:Standard'">
                Virtual Observatory Standard
            </xsl:when>
            <xsl:otherwise>
                Virtual Observatory Resource
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="accessURL|mirrorURL" mode="browser">
        <a>
              <xsl:attribute name="href">
                  <xsl:value-of select="."/>
              </xsl:attribute>
              <xsl:value-of select="."/>
        </a>
        <br/>
    </xsl:template>

    <xsl:template match="accessURL|mirrorURL" mode="non-web">
        <span class="serviceURL">
            <a title="Copy this URL and paste it into a suitable client"
                onclick="return false">
                <xsl:attribute name="href">
                    <xsl:value-of select="."/>
                </xsl:attribute>
                <xsl:value-of select="."/>
            </a>
        </span>
        <br/>
    </xsl:template>

    <xsl:template match="interface" mode="non-web">
        <xsl:apply-templates select="accessURL" mode="non-web"/>
        <xsl:apply-templates select="mirrorURL" mode="non-web"/>
    </xsl:template>

    <xsl:template match="capability[interface[@xsi:type='vr:WebBrowser']]">
        <dt class="browsable">Web browser access <span class="protocol">HTML</span></dt>
        <dd><xsl:apply-templates select="interface" mode="browser"/></dd>
    </xsl:template>

<!---
    <xsl:template match="capability[interface[@xsi:type='doc:StaticFile']]">
        <dt class="browsable">Static File <span class="protocol"
            ><xsl:value-of select="></span></dt>
        <dd><xsl:apply-templates select="interface" mode="browser"/></dd>
    </xsl:template> -->

    <xsl:template match="capability" mode="conesearch">
        <dt>IVOA Cone Search <span class="protocol">SCS</span></dt>
        <dd>For use with a cone search client (e.g., TOPCAT).<br/>
            <xsl:apply-templates select="interface" mode="non-web"/>
        </dd>
    </xsl:template>

    <xsl:template match="capability" mode="siap">
        <dt>IVOA Simple Image Search <span class="protocol">SIAP</span></dt>
        <dd>For use with a VO-enabled image processor (e.g., Aladin).<br/>
            <xsl:apply-templates select="interface" mode="non-web"/>
        </dd>
    </xsl:template>

    <xsl:template match="capability" mode="ssap">
        <dt>IVOA Simple Spectrum Search <span class="protocol">SSAP</span></dt>
        <dd>For use with a VO-enabled spectral analysis program
            (e.g., Splat, VOSpec).<br/>
            <xsl:apply-templates select="interface" mode="non-web"/>
        </dd>
    </xsl:template>

    <xsl:template match="capability" mode="tap">
        <dt>IVOA Table Access <span class="protocol">TAP</span></dt>
        <dd><xsl:apply-templates select="interface" mode="non-web"/>
           <span class="explanation">Run SQL-like queries with TAP-enabled clients (e.g., TOPCAT).</span>
        </dd>
    </xsl:template>

    <xsl:template match="capability" mode="slap">
        <dt>IVOA Simple Line Access <span class="protocol">SLAP</span></dt>
        <dd><xsl:apply-templates select="interface" mode="non-web"/>
           <span class="explanation">Find spectral lines.</span>
        </dd>
    </xsl:template>

    <xsl:template match="capability" mode="examples">
        <dt>DALI Examples <span class="protocol">DALI</span></dt>
        <dd><xsl:apply-templates select="interface" mode="browser"/>
          <span class="explanation">RDFa-annotated human-readable
            usage examples.</span>
        </dd>
    </xsl:template>

    <xsl:template match="capability[@standardID]">
        <xsl:variable name="standardID"
            select="translate(@standardID,
                'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
                'abcdefghijklmnopqrstuvwxyz')"/>
        <xsl:choose>
            <xsl:when test="starts-with($standardID,
                'ivo://ivoa.net/std/conesearch')">
                <xsl:apply-templates select="." mode="conesearch"/>
            </xsl:when>

            <xsl:when test="starts-with($standardID,
                'ivo://ivoa.net/std/vosi')">
                <!-- don't show VOSI endpoints at this point; let's see
                what people think -->
            </xsl:when>

            <xsl:when test="starts-with($standardID,
                'ivo://ivoa.net/std/tap')">
                <xsl:apply-templates select="." mode="tap"/>
            </xsl:when>

            <xsl:when test="starts-with($standardID,
                'ivo://ivoa.net/std/sia')">
                <xsl:apply-templates select="." mode="siap"/>
            </xsl:when>

            <xsl:when test="starts-with($standardID,
                'ivo://ivoa.net/std/ssa')">
                <xsl:apply-templates select="." mode="ssap"/>
            </xsl:when>

            <xsl:when test="starts-with($standardID,
                'ivo://ivoa.net/std/slap')">
                <xsl:apply-templates select="." mode="slap"/>
            </xsl:when>

            <xsl:when test="starts-with($standardID,
                'ivo://ivoa.net/std/dali#examples')">
                <xsl:apply-templates select="." mode="examples"/>
            </xsl:when>

            <xsl:otherwise>
                <dt>Unknown endpoint</dt>
                <dd>Capability for unknown standard <xsl:value-of
                    select="$standardID"/>.
                    The VO Registry may have more details; look for
                    IVOID
                    <xsl:value-of select="/ri:Resource/identifier"/>.</dd>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
<!-- vim:et:sw=4:sta
-->
