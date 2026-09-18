<resource schema="ccd_observations" resdir=".">
  <meta name="creationDate">2026-08-18T00:00:00Z</meta>

  <meta name="title">FAI CCD Photometric Observations</meta>
  <meta name="description">
    Reduced, astrometrically calibrated CCD images obtained with telescopes
    operated by the Fesenkov Astrophysical Institute.  The initial release
    contains observations from the Zeiss-1000 East telescope at the Tian Shan
    Astronomical Observatory; further FAI telescopes will be added as their
    reduced data become available.  Discovery metadata remain public during
    proprietary periods.  Before the RELEASE date, downloads contain the
    original FITS headers but zero-valued data arrays; afterwards the original
    FITS product is delivered.
  </meta>
  <meta name="subject">ccd-observation</meta>
  <meta name="subject">photometry</meta>
  <meta name="subject">optical-observation</meta>

  <meta name="creator">Fesenkov Astrophysical Institute</meta>
  <meta name="instrument">CCD cameras</meta>
  <meta name="facility">Tian Shan Astronomical Observatory</meta>
  <meta name="facility">Fesenkov Astrophysical Institute</meta>

  <meta name="contentLevel">Research</meta>
  <meta name="type">Archive</meta>
  <meta name="coverage.waveband">Optical</meta>

  <!--
    The read-only observations NFS is mounted directly below inputsDir as
    /var/gavo/inputs/observations.  No copy or writable link is needed.
  -->

  <table id="main" onDisk="True" adql="True"
      primary="source_path" forceUnique="True" dupePolicy="overwrite">
    <mixin>//siap2#pgs</mixin>
    <mixin preview="NULL">//obscore#publishObscoreLike</mixin>

    <column name="telescope_name" type="text"
      ucd="instr.tel"
      tablehead="Telescope"
      description="Telescope inferred from the managed archive path."
      verbLevel="1"/>
    <column name="filter_name" type="text"
      ucd="meta.id;instr.filter"
      tablehead="Filter"
      description="Normalised photometric filter name."
      verbLevel="1"/>
    <column name="image_type" type="text"
      ucd="meta.code.class;obs"
      tablehead="Image type"
      description="Image type reported by the FITS header."
      verbLevel="5"/>
    <column name="ncombine" type="integer" required="True"
      ucd="meta.number"
      tablehead="Combined"
      description="Number of individual exposures combined into the product."
      verbLevel="5"/>
    <column name="x_binning" type="integer" required="True"
      ucd="meta.number;instr.pixel"
      tablehead="X bin"
      description="Detector binning along the first image axis."
      verbLevel="5"/>
    <column name="y_binning" type="integer" required="True"
      ucd="meta.number;instr.pixel"
      tablehead="Y bin"
      description="Detector binning along the second image axis."
      verbLevel="5"/>
    <column name="release_date" type="date"
      ucd="time.release"
      tablehead="Public after"
      description="Date on which the FITS product becomes publicly accessible."
      verbLevel="1"/>
    <column name="data_policy_class" type="text"
      ucd="meta.code.class"
      tablehead="Policy"
      description="FAI data-policy class from the OBS-CLSS FITS keyword."
      verbLevel="5"/>
    <column name="proposal_id" type="text"
      ucd="meta.id;obs.proposal"
      tablehead="Proposal"
      description="FAI observing-proposal identifier."
      verbLevel="5"/>
    <column name="pi_name" type="text"
      ucd="meta.id.assoc"
      tablehead="PI"
      description="Principal investigator named in the FITS header."
      verbLevel="15"/>
    <column name="coi_name" type="text"
      ucd="meta.id.assoc"
      tablehead="Co-I"
      description="Co-investigators named in the FITS header."
      verbLevel="15"/>
    <column name="source_path" type="text" required="True"
      ucd="meta.ref.url;meta.file"
      tablehead="Source"
      description="Path of the source FITS relative to the DaCHS inputs directory."
      verbLevel="25"/>
    <column name="source_mtime" type="timestamp" required="True"
      ucd="time;meta.file"
      tablehead="Source modified"
      description="Modification time of the source FITS at its latest ingest."
      verbLevel="25"/>
  </table>

  <coverage>
    <updater sourceTable="main"/>
  </coverage>

  <data id="import" updating="True">
    <!--
      Only final master stacks from the requested telescope are considered.
      fromdbUpdating skips unchanged files but re-ingests a file if its header
      is updated (in particular, when RELEASE metadata changes).
    -->
    <sources>
      <pattern>../observations/tshao/zeiss1000_east/ccd/targets/*/*/reduced/*_master.fits</pattern>
      <pattern>../observations/tshao/zeiss1000_east/ccd/targets/*/*/reduced/*_master.fit</pattern>
      <ignoreSources
          fromdbUpdating="SELECT source_path, source_mtime FROM \schema.main">
        <pattern>*/_tmp_processing_sandbox/*</pattern>
      </ignoreSources>
    </sources>

    <fitsProdGrammar qnd="True">
      <!--
        RELEASE is an ISO date.  A valid date protects the product until that
        date; metadata remain queryable.  Missing RELEASE means public.  A
        malformed non-empty RELEASE fails closed until the header is corrected.
      -->
      <rowfilter procDef="//products#define">
        <setup imports="datetime, hashlib">
          <code><![CDATA[
            def getAccref(sourcePath):
              # Keep the real (possibly URL-hostile) file name in accesspath,
              # but expose a stable URL-safe product identifier.
              digest = hashlib.sha256(sourcePath.encode("utf-8")).hexdigest()
              return "ccd_observations/products/{}.fits".format(digest)

            def getEmbargo(row):
              release = str(row.get("RELEASE") or "").strip()
              if release:
                try:
                  return datetime.date.fromisoformat(release[:10])
                except ValueError:
                  return datetime.date.max

              return None
          ]]></code>
        </setup>
        <bind key="table">"\schema.main"</bind>
        <bind key="accref">getAccref(\inputRelativePath{True})</bind>
        <bind key="owner">"ccd-observations"</bind>
        <bind key="embargo">getEmbargo(row)</bind>
        <bind key="mime">"application/fits"</bind>
        <bind key="preview">None</bind>
      </rowfilter>
    </fitsProdGrammar>

    <make table="main">
      <rowmaker>
        <apply name="prepareMetadata">
          <setup imports="datetime">
            <code><![CDATA[
              FILTER_NAMES = {
                "U_JOHNSON": "Johnson U",
                "B_JOHNSON": "Johnson B",
                "V_JOHNSON": "Johnson V",
                "R_JOHNSON": "Johnson R",
                "I_JOHNSON": "Johnson I",
                "SLOAN_U": "SDSS u",
                "SLOAN_G": "SDSS g",
                "SLOAN_R": "SDSS r",
                "SLOAN_I": "SDSS i",
                "SLOAN_Z": "SDSS z",
              }
              SITE_NAMES = {
                "tshao": "Tian Shan Astronomical Observatory",
                "assy": "Assy-Turgen Observatory",
              }
              TELESCOPE_NAMES = {
                "zeiss1000_east": "Zeiss-1000 East",
                "zeiss1000_west": "Zeiss-1000 West",
                "azt20": "AZT-20",
                "wfos400": "WFOS-400",
                "wfos7000": "WFOS-7000",
              }

              def cleanText(value):
                return str(value or "").strip()

              def normaliseFilter(value):
                raw = cleanText(value)
                key = raw.upper().replace("-", "_").replace(" ", "_")
                if key in ("CLEAR", "NONE", "OPEN"):
                  return None
                return FILTER_NAMES.get(key, raw or None)

              def pathMetadata(accref):
                parts = accref.split("/")
                try:
                  observations_index = parts.index("observations")
                  site_key = parts[observations_index+1]
                  telescope_key = parts[observations_index+2]
                except (ValueError, IndexError):
                  return "Unknown facility", "Unknown telescope"
                return (
                  SITE_NAMES.get(site_key, site_key.replace("_", " ").title()),
                  TELESCOPE_NAMES.get(
                    telescope_key, telescope_key.replace("_", " ").title()))
          ]]></code>
          </setup>
          <code><![CDATA[
            @facility_name, @telescope_name = pathMetadata(@prodtblAccref)
            @instrument_name = cleanText(vars.get("INSTRUME")) or @telescope_name
            @target_name = cleanText(vars.get("OBJECT")) or None
            @filter_name = normaliseFilter(vars.get("FILTER"))
            @image_type = cleanText(vars.get("IMAGETYP")) or None
            @date_obs = cleanText(
              vars.get("DATE-OBS") or vars.get("DATE_OBS"))
            @single_exptime = float(
              vars.get("EXPTIME") or vars.get("EXPOSURE") or 0.0)
            @ncombine = int(vars.get("NCOMBINE") or 1)
            @total_exptime = @single_exptime * @ncombine
            @x_binning = int(vars.get("XBINNING") or 1)
            @y_binning = int(vars.get("YBINNING") or 1)
            @data_policy_class = cleanText(vars.get("OBS_CLSS")) or None
            @proposal_id = cleanText(vars.get("PROPOSID")) or None
            @pi_name = cleanText(vars.get("PI_NAME")) or None
            @coi_name = cleanText(vars.get("COI_NAME")) or None

            if @date_obs:
              @t_min = dateTimeToMJD(parseTimestamp(@date_obs))
              @t_max = @t_min + @total_exptime/86400.0
            else:
              @t_min = None
              @t_max = None

            release = cleanText(vars.get("RELEASE"))
            try:
              @release_date = parseTimestamp(release).date() if release else None
              @product_embargoed = (
                @release_date is not None
                and @release_date > datetime.date.today())
            except ValueError:
              @release_date = None
              # This mirrors getEmbargo above: malformed non-empty RELEASE
              # values fail closed, but still receive a safe zero-data copy.
              @product_embargoed = bool(release)
          ]]></code>
        </apply>

        <apply procDef="//siap2#computePGS">
          <!-- Keep metadata-only rows even when a reduced image lacks WCS. -->
          <bind key="missingIsError">False</bind>
          <bind key="ignoreBrokenWCS">True</bind>
        </apply>

        <apply procDef="//siap2#setMeta">
          <bind key="dataproduct_type">"image"</bind>
          <bind key="dataproduct_subtype">"science"</bind>
          <bind key="calib_level">3</bind>
          <bind key="obs_collection">"FAI CCD Photometry"</bind>
          <bind key="obs_id">@prodtblAccref</bind>
          <bind key="obs_title">"{} | {} | {} | {}".format(
            @target_name or "Unknown target",
            @filter_name or "unfiltered",
            @telescope_name,
            @date_obs[:10] if @date_obs else "unknown date")</bind>
          <bind key="obs_publisher_did">\standardPubDID</bind>
          <bind key="obs_creator_did">None</bind>
          <bind key="target_name">@target_name</bind>
          <bind key="target_class">None</bind>
          <bind key="t_min">@t_min</bind>
          <bind key="t_max">@t_max</bind>
          <bind key="t_exptime">@total_exptime</bind>
          <bind key="t_resolution">None</bind>
          <bind key="bandpassId">@filter_name</bind>
          <bind key="em_res_power">None</bind>
          <bind key="em_ucd">None</bind>
          <bind key="o_ucd">"phot.count"</bind>
          <bind key="pol_states">None</bind>
          <bind key="facility_name">@facility_name</bind>
          <bind key="instrument_name">@instrument_name</bind>
          <bind key="t_xel">None</bind>
          <bind key="em_xel">1</bind>
          <bind key="pol_xel">None</bind>
        </apply>

        <apply name="setSafeAccessURL">
          <setup imports="os, urllib.parse">
            <code><![CDATA[
              def makeSafeAccessURL(accref, sourcePath):
                digest = os.path.basename(accref).removesuffix(".fits")
                fileName = urllib.parse.quote(
                  os.path.basename(sourcePath), safe="")
                return (str(base.getConfig("web", "serverURL")).rstrip("/")
                  + "/ccd_observations/q/zeroed/qp/"
                  + digest + "/" + fileName)
            ]]></code>
          </setup>
          <code><![CDATA[
            if @product_embargoed:
              result["access_url"] = makeSafeAccessURL(
                @prodtblAccref, @prodtblPath)
          ]]></code>
        </apply>

        <apply procDef="//siap2#getBandFromFilter"/>

        <map key="telescope_name">@telescope_name</map>
        <map key="filter_name">@filter_name</map>
        <map key="image_type">@image_type</map>
        <map key="ncombine">@ncombine</map>
        <map key="x_binning">@x_binning</map>
        <map key="y_binning">@y_binning</map>
        <map key="release_date">@release_date</map>
        <map key="data_policy_class">@data_policy_class</map>
        <map key="proposal_id">@proposal_id</map>
        <map key="pi_name">@pi_name</map>
        <map key="coi_name">@coi_name</map>
        <map key="source_path">@prodtblPath</map>
        <map key="source_mtime">datetime.datetime.utcfromtimestamp(
          os.path.getmtime(\fullPath))</map>
      </rowmaker>
    </make>
  </data>

  <service id="browse" allowed="form">
    <meta name="shortName">FAI CCD browser</meta>
    <meta name="title">Browse FAI CCD Photometric Observations</meta>
    <dbCore queriedTable="main">
      <condDesc original="//siap2#humanInput"/>
      <condDesc>
        <inputKey name="object_search" type="text" multiplicity="single"
          tablehead="Object"
          description="Target-name fragment. Matching ignores case, spaces and punctuation. A complete SIMBAD alias is also accepted; if SIMBAD is unavailable, local-name matching still works.">
          <widgetFactory><![CDATA[widgetFactory(StringFieldWithBlurb,
              additionalMaterial=T.script(type="text/javascript")["""
                (function() {
                  var input = document.getElementById("genForm-object_search");
                  if (!input) { return; }
                  input.placeholder = "e.g. BX Mon, bxmon, CH-Cyg";

                  var field = input.closest(".field");
                  var box = document.createElement("div");
                  field.style.position = "relative";
                  box.style.display = "none";
                  box.style.position = "absolute";
                  box.style.left = input.offsetLeft + "px";
                  box.style.top = (input.offsetTop + input.offsetHeight + 2) + "px";
                  box.style.zIndex = "1000";
                  box.style.minWidth = Math.max(input.offsetWidth, 260) + "px";
                  box.style.maxHeight = "18em";
                  box.style.overflowY = "auto";
                  box.style.background = "white";
                  box.style.border = "1px solid #888";
                  box.style.boxShadow = "0 3px 8px rgba(0,0,0,.25)";
                  field.appendChild(box);

                  var names = [];
                  var normalise = function(value) {
                    return String(value || "").toLowerCase().replace(/[^a-z0-9]/g, "");
                  };
                  var hide = function() { box.style.display = "none"; };
                  var render = function() {
                    var needle = normalise(input.value);
                    box.replaceChildren();
                    if (!needle) { hide(); return; }

                    var matches = names.filter(function(name) {
                      return normalise(name).indexOf(needle) !== -1;
                    }).slice(0, 12);
                    if (!matches.length) { hide(); return; }

                    matches.forEach(function(name) {
                      var item = document.createElement("button");
                      item.type = "button";
                      item.textContent = name;
                      item.style.display = "block";
                      item.style.width = "100%";
                      item.style.padding = ".25em .5em";
                      item.style.border = "0";
                      item.style.background = "white";
                      item.style.textAlign = "left";
                      item.style.cursor = "pointer";
                      item.addEventListener("mousedown", function(event) {
                        event.preventDefault();
                        input.value = name;
                        hide();
                      });
                      box.appendChild(item);
                    });
                    box.style.display = "block";
                  };

                  var tapQuery = new URLSearchParams({
                    REQUEST: "doQuery",
                    LANG: "ADQL",
                    FORMAT: "json",
                    QUERY: "SELECT DISTINCT target_name FROM ccd_observations.main WHERE target_name IS NOT NULL ORDER BY target_name"
                  });
                  fetch("/tap/sync?" + tapQuery.toString())
                    .then(function(response) {
                      if (!response.ok) { throw new Error("target list unavailable"); }
                      return response.json();
                    })
                    .then(function(payload) {
                      names = payload.data.map(function(row) { return row[0]; });
                      render();
                    })
                    .catch(function() { names = []; });

                  input.addEventListener("input", render);
                  input.addEventListener("focus", render);
                  input.addEventListener("blur", function() {
                    window.setTimeout(hide, 150);
                  });
                })();
              """])]]></widgetFactory>
        </inputKey>
        <phraseMaker>
          <setup imports="re">
            <code><![CDATA[
              def normaliseObjectName(value):
                return re.sub(r"[^0-9a-z]+", "", str(value or "").lower())
            ]]></code>
          </setup>
          <code><![CDATA[
            rawName = inPars.get("object_search")
            needle = normaliseObjectName(rawName)
            if needle:
              clauses = [
                "regexp_replace(lower(target_name), "
                "'[^a-z0-9]+', '', 'g') LIKE %%(%s)s"%(
                  base.getSQLKey("object_search", "%"+needle+"%", outPars))]

              # DaCHS' Sesame client caches successful SIMBAD resolutions in
              # dc.metastore.  SIMBAD therefore helps with aliases without
              # becoming a hard dependency of the local catalogue search.
              try:
                simbadRecord = base.caches.getSesame("web").query(rawName)
              except Exception:
                simbadRecord = None

              if simbadRecord:
                roi = pgsphere.SCircle.fromDALI([
                  float(simbadRecord["RA"]),
                  float(simbadRecord["dec"]),
                  0.05])
                clauses.append("s_region && %%(%s)s"%(
                  base.getSQLKey("object_position", roi, outPars)))

              yield "("+" OR ".join(clauses)+")"
          ]]></code>
        </phraseMaker>
      </condDesc>
      <condDesc>
        <inputKey original="telescope_name" showItems="8" multiplicity="multiple">
          <values fromdb="telescope_name FROM \schema.main ORDER BY telescope_name"/>
        </inputKey>
      </condDesc>
      <condDesc>
        <inputKey original="filter_name" showItems="8" multiplicity="multiple">
          <values fromdb="filter_name FROM \schema.main ORDER BY filter_name"/>
        </inputKey>
      </condDesc>
      <condDesc>
        <inputKey name="embargoed_only" type="boolean" multiplicity="single"
          required="False" tablehead="Only under embargo"
          description="Show only records whose FITS product is still under embargo; discovery metadata remain public."/>
        <phraseMaker>
          <code><![CDATA[
            if inPars.get("embargoed_only"):
              yield "release_date IS NOT NULL AND release_date>CURRENT_DATE"
          ]]></code>
        </phraseMaker>
      </condDesc>
      <outputTable autoCols="obs_title,target_name,telescope_name,filter_name,t_min,t_exptime,release_date,data_policy_class">
        <column original="access_url"/>
        <column original="s_ra" displayHint="type=hms"/>
        <column original="s_dec" displayHint="type=dms"/>
      </outputTable>
    </dbCore>
  </service>

  <service id="i" allowed="form,siap2.xml">
    <meta name="shortName">FAI CCD SIA2</meta>
    <meta name="title">FAI CCD Photometric Image Service</meta>
    <meta name="sia.type">Pointed</meta>
    <meta name="testQuery.pos.ra">135.86386</meta>
    <meta name="testQuery.pos.dec">32.05221</meta>
    <meta name="testQuery.size.ra">0.2</meta>
    <meta name="testQuery.size.dec">0.2</meta>

    <publish render="siap2.xml" sets="ivo_managed"/>
    <publish render="form" sets="local,ivo_managed" service="browse"/>

    <dbCore queriedTable="main">
      <FEED source="//siap2#parameters"/>
      <condDesc buildFrom="telescope_name"/>
      <condDesc buildFrom="filter_name"/>
      <condDesc buildFrom="release_date"/>
    </dbCore>
  </service>

  <!--
    Public delivery for proprietary products.  The source file is opened
    read-only.  Header blocks are copied byte-for-byte and every FITS data
    block is replaced with zero bytes in the response buffer.  dc.products
    remains embargoed, so the original /getproduct URL is never exposed here.
  -->
  <service id="zeroed" allowed="qp">
    <meta name="shortName">FAI safe FITS download</meta>
    <meta name="title">Download an FAI CCD FITS product safely</meta>
    <property name="queryField">product</property>
    <pythonCore>
      <inputTable>
        <inputKey name="product" type="text" required="True"/>
      </inputTable>
      <coreProc>
        <setup imports="datetime, io, os, re">
          <code><![CDATA[
            from astropy.io import fits
            from gavo import svcs

            ZERO_CHUNK = b"\0"*(1024*1024)
            MAX_PRODUCT_SIZE = 512*1024*1024
            PRODUCT_PREFIX = "ccd_observations/products/"

            def writeZeros(dest, byteCount):
              while byteCount:
                chunkSize = min(byteCount, len(ZERO_CHUNK))
                dest.write(ZERO_CHUNK[:chunkSize])
                byteCount -= chunkSize

            def makeZeroDataFITS(sourcePath):
              sourceSize = os.path.getsize(sourcePath)
              if sourceSize > MAX_PRODUCT_SIZE:
                raise svcs.Error("FITS product is too large for safe delivery")

              # Astropy reads the HDU layout but leaves image arrays on disk.
              # fileinfo then lets us copy header blocks exactly while never
              # reading the proprietary data bytes.
              with fits.open(sourcePath, mode="readonly", memmap=True,
                  do_not_scale_image_data=True,
                  lazy_load_hdus=False) as hdus:
                infos = [hdus.fileinfo(index)
                  for index in range(len(hdus))]

              result = io.BytesIO()
              cursor = 0
              with open(sourcePath, "rb") as source:
                for info in infos:
                  headerStart = int(info["hdrLoc"])
                  dataStart = int(info["datLoc"])
                  dataSpan = int(info["datSpan"])
                  if headerStart != cursor or dataStart < headerStart:
                    raise svcs.Error("Unexpected FITS block layout")

                  source.seek(headerStart)
                  header = source.read(dataStart-headerStart)
                  if len(header) != dataStart-headerStart:
                    raise svcs.Error("Truncated FITS header")
                  result.write(header)
                  writeZeros(result, dataSpan)
                  cursor = dataStart+dataSpan

              # Do not copy non-HDU trailing bytes; zero them as well so no
              # unparsed source content can leak into the public response.
              if cursor > sourceSize:
                raise svcs.Error("Invalid FITS data span")
              writeZeros(result, sourceSize-cursor)
              return result.getvalue()
          ]]></code>
        </setup>
        <code><![CDATA[
          requestPath = str(inputTable.getParam("product") or "")
          pathParts = requestPath.split("/", 1)
          if (len(pathParts) != 2
              or not re.fullmatch(r"[0-9a-f]{64}", pathParts[0])):
            raise svcs.UnknownURI("Invalid CCD product identifier")

          accref = PRODUCT_PREFIX+pathParts[0]+".fits"
          with base.getTableConn() as conn:
            rows = list(conn.query(
              "SELECT accesspath, embargo FROM dc.products "
              "WHERE accref=%(accref)s "
              "AND sourcetable='ccd_observations.main' "
              "AND mime='application/fits'",
              {"accref": accref}))
          if len(rows) != 1:
            raise svcs.UnknownURI("No such CCD product")

          accessPath, embargo = rows[0]
          sourcePath = os.path.realpath(os.path.join(
            str(base.getConfig("inputsDir")), accessPath))
          inputsRoot = os.path.realpath(str(base.getConfig("inputsDir")))
          if os.path.commonpath([inputsRoot, sourcePath]) != inputsRoot:
            raise svcs.UnknownURI("Unsafe CCD product path")
          if os.path.basename(sourcePath) != pathParts[1]:
            raise svcs.UnknownURI("CCD product name does not match")
          if not os.path.isfile(sourcePath):
            raise svcs.UnknownURI("CCD product file is unavailable")

          if embargo is not None and embargo > datetime.date.today():
            payload = makeZeroDataFITS(sourcePath)
          else:
            with open(sourcePath, "rb") as source:
              payload = source.read()
          return "application/fits", payload
        ]]></code>
      </coreProc>
    </pythonCore>
  </service>

  <regSuite title="ccd_observations regression">
    <regTest title="SIAP2 returns FAI CCD metadata">
      <url POS="CIRCLE 135.86386 32.05221 0.2" MAXREC="5">i/siap2.xml</url>
      <code>
        row = self.getFirstVOTableRow()
        self.assertEqual(row["obs_collection"], "FAI CCD Photometry")
        self.assertEqual(row["target_name"], "Spektr")
        self.assertEqual(row["access_format"], "application/fits")
      </code>
    </regTest>

    <regTest title="An embargoed image is delivered with zero-valued data">
      <url>zeroed/qp/ee328a06cfcfd37fe76f120beb7a991e0008fe817e81cf790306d307a3f9ce40/NGC5548_B-JOHNSON_ex90s_bin2_2026-07-11_master.fits</url>
      <code>
        self.assertHTTPStatus(200)
        self.assertTrue(self.data.startswith(b"SIMPLE  ="))
        endOffset = next(offset for offset in range(0, len(self.data), 80)
          if self.data[offset:offset+8]==b"END     ")
        dataStart = ((endOffset+80+2879)//2880)*2880
        self.assertTrue(dataStart &lt; len(self.data))
        self.assertFalse(self.data[dataStart:].strip(b"\0"))
      </code>
    </regTest>
  </regSuite>
</resource>
