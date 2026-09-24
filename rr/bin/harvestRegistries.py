"""
Retrieve records from the registries in the rr.registries table and
ingest them into the registry tables.

We normally do incremental harvesting in fairly narrow intervals.
However, now and then we do a full harvest, removing all data
harvested from a given registry.  The latter process needs some trickery.

We're harvesting into the file system (as opposed to directly into the
data base).  For easy managing, each registry has their files in a directory
of its own.  Each file is named after the date of retrieval.
"""

import datetime
import os
import sys
import time

import lockfile   # debian package python-lockfile

from gavo import api
from gavo import base
from gavo.base import osinter
from gavo.protocols import oaiclient
from gavo.registry.model import OAI
from gavo.utils import stanxml


RDID = "rr/q"
RD = api.getRD(RDID)

api.setUserAgent(f"KazVO-RegTAP-harvester DaCHS/{api.__version__}")


class HarvestContext:
	"""A harvesting context.

	Right now, we collect information on what registries were
	fully reharvested here, plus there's an updating
	registry table in the regTable attribute.
	"""
	fullInterval = datetime.timedelta(days=100)
	# The local mirror is refreshed twice daily by dachs-rr-harvest.timer.
	# Keep this below the 12-hour timer interval so every scheduled run is due.
	incInterval = datetime.timedelta(hours=11)

	def __init__(self, regTable, forceFrom=None):
		self.regTable = regTable
		self.forceFrom = forceFrom


def getDirnameFor(regId):
	"""returns a directory name for data retrieved from the registry with
	IVORN regId.

	As a side effect, the function ensures the directory exists.

	Currently, we are naive and assume each authority runs at most one
	registry; hence, we only need the authority part of regId, which
	happens to be a valid directory name.

	The assumptins here are refleted in res/vorgrammar.makeDataPack.
	"""
	assert regId.startswith("ivo://")
	dirName = os.path.join(RD.resdir, "data", regId.split("/")[2])
	if not os.path.isdir(dirName):
		osinter.makeSharedDir(dirName)
	return dirName


def unlinkInDir(dirName):
	for fName in os.listdir(dirName):
		os.unlink(os.path.join(dirName, fName))


def makeSaver(dbRec, destDir=None):
	"""returns a OAIQuery contentCallback to save data for the registry
	described in dbRec.
	"""
	if destDir is None:
		destDir = getDirnameFor(dbRec["ivoid"])

	def saver(content):
		with lockfile.FileLock(os.path.join(destDir, "lock")):
			while True:
				name = datetime.datetime.utcnow().strftime("%Y%m%d%H%M%S.oaixml")
				if os.path.exists(os.path.join(destDir, name)):
					time.sleep(0.1)
				else:
					f = open(os.path.join(destDir, name), "wb")
					break
		f.write(content)
		f.close()

	return saver


def updateDB(dbRec, context):
	"""writes a registry record into the database.
	"""


def _buildDeletedRecordsFor(registryIvoid, destF):
	"""writes deleted records for all records harvested from
	registryIvoid to destF.

	We do this to make sure that on a full re-harvest all existing records
	are deleted unless they are explicitly mentioned in the new harvest.
	"""
	with base.getTableConn() as conn:
		toDelete = [r[0] for r in
			conn.query("select ivoid from rr.resource where"
			" harvested_from=%(registryIvoid)s", locals())]

	fakedResponseTimestamp = "1970-01-01T12:00:00Z"
	tree = OAI.PMH[
		OAI.responseDate[fakedResponseTimestamp],
		OAI.request(verb="ListRecords", metadataPrefix="ivo_vor")[
			"http://invalid/dachs/internal/_buildDeletedRecords"],
		OAI.ListRecords[
			[OAI.record[
				OAI.header(status="deleted")[
					OAI.identifier[id],
					OAI.datestamp[fakedResponseTimestamp],]]
			for id in toDelete]]]
	
	stanxml.xmlwrite(tree, destF)


def _harvestOneFull(dbRec, context):
	# since we don't want to fail hard when a publishing registry is
	# down right when we want to harvest it, we first harvest into
	# a temporary, auxiliary directory.  Only when that has actually
	# worked do we proceed to remove the existing data.
	base.ui.notifyInfo("Full harvest of %s"%dbRec["title"])
	harvestDT = datetime.datetime.utcnow()
	harvestInto = getDirnameFor(dbRec["ivoid"])+"-harvesting"
	dirForRegistry = getDirnameFor(dbRec["ivoid"])
	if os.path.isdir(harvestInto):
		base.ui.notifyWarning(
			"Removing stale staging directory %s from an interrupted harvest"
			% harvestInto)
		unlinkInDir(harvestInto)
		os.rmdir(harvestInto)
	os.mkdir(harvestInto)

	try:
		# make sure all records are deleted by prepending an all-delete
		# artificial OAI result
		with open(os.path.join(harvestInto,
				"0000000artificial-deleted-existing.oaixml"), "wb") as f:
			_buildDeletedRecordsFor(dbRec["ivoid"], f)

		q = oaiclient.OAIQuery(
			dbRec["accessurl"],
			verb="ListRecords",
			set="ivo_managed",
			contentCallback=makeSaver(dbRec, destDir=harvestInto))
		# XXX TODO: remove the excessive timeout again when heasarc fixes
		# their OAI code.
		q.timeout = 600
		q.talkOAI(oaiclient.IdParser)

		# ok, it seems we've suceeded harvesting.  Let's clean up
		# the existing directory and move in the files we've just harvested
		unlinkInDir(dirForRegistry)
		for fName in os.listdir(harvestInto):
			os.rename(
				os.path.join(harvestInto, fName),
				os.path.join(dirForRegistry, fName))
	except:
		# something went wrong while harvesting; remove our temporary
		# directory and bail out
		unlinkInDir(harvestInto)
		os.rmdir(harvestInto)
		raise

	# We've now a set of fresh records in dirForRegistry.  Note down
	# the success and drop the record of previously parsed files
	# from that directory.
	os.rmdir(harvestInto)
	dbRec["last_full_harvest"] = dbRec["last_inc_harvest"] = harvestDT
	context.regTable.addRow(dbRec)

	regPattern = "%s%%"%api.getInputsRelativePath(dirForRegistry
		).replace("%", "%%").replace("_", "__")
	with base.getWritableAdminConn() as conn:
		conn.execute("DELETE FROM rr.imported WHERE path LIKE %(rp)s",
			{"rp": regPattern})


def _harvestOneInc(dbRec, context):
	base.ui.notifyInfo("Incremental harvest of %s"%dbRec["title"])
	harvestDT = datetime.datetime.utcnow()

	if context.forceFrom:
		startDate = context.forceFrom
	else:
		startDate = dbRec["last_inc_harvest"]-context.incInterval

	granularity = oaiclient.getServerProperties(
		dbRec["accessurl"]).granularity
	q = oaiclient.OAIQuery(
		dbRec["accessurl"],
		verb="ListRecords",
		set="ivo_managed",
		startDate=startDate,
		endDate=datetime.datetime.utcnow(),
		contentCallback=makeSaver(dbRec),
		granularity=granularity)
	q.talkOAI(oaiclient.IdParser)

	dbRec["last_inc_harvest"] = harvestDT
	context.regTable.addRow(dbRec)


def harvestOne(dbRec, context):
	"""harvests the registry described in dbRec if the time is right.

	dbRec is a row from the registries table.
	"""
	now = datetime.datetime.utcnow()
	if (dbRec["last_full_harvest"] is None
			or dbRec["last_full_harvest"]+context.fullInterval<now):
		_harvestOneFull(dbRec, context)
	elif dbRec["last_inc_harvest"]+context.incInterval<now:
		_harvestOneInc(dbRec, context)


def parseCommandLine():
	import argparse
	parser = argparse.ArgumentParser(description="Harvest all registries"
		" that are due (or the ones SQL-matching the command line")
	parser.add_argument("-f", "--force", type=str,
		help="Only harvest registries matching the SQL pattern given, regardless"
		" of whether or not they are due.", dest="idPat",
		default=None)
	parser.add_argument("-F", "--force-full", type=str,
		help="Only harvest registries matching the SQL pattern given, regardless"
		" of whether or not they are due; do a full re-harvest rather than"
		" an incremental.  Overrides -f.", dest="forceIdPat", default=None)
	parser.add_argument("-D", "--force-date", 
		type=api.parseISODT,
		dest="forceFrom", metavar="DATE",
		help="Use DATE (whatever gavo.utils.parseISODT understands) rather than"
			"the last harvest date as the start date in incremental harvesting.")

	return parser.parse_args()


def main():
	retval = 0
	regTD = RD.getById("registries")
	args = parseCommandLine()

	with api.getWritableAdminConn() as conn:
		regTable = api.TableForDef(regTD, connection=conn,
			parseOptions=api.parseValidating.change(doTableUpdates=True))
		context = HarvestContext(regTable, args.forceFrom)

		regpat = '%'
		if args.idPat:
			regpat = args.idPat
			conn.execute("update rr.registries"
				" set last_inc_harvest=last_inc_harvest-interval '24 hours'"
				" where ivoid like %(regpat)s", locals())
		if args.forceIdPat:
			regpat = args.forceIdPat
			conn.execute("update rr.registries set last_full_harvest='1970-01-01'"
				" where ivoid like %(regpat)s", locals())

		for rec in regTable.iterQuery(regTD, "ivoid like %(regpat)s",
				{"regpat": regpat}):
			try:
				harvestOne(rec, context)
				# treat every registry separately
				conn.commit()
			except Exception as msg:
#				import traceback; traceback.print_exc()
				base.ui.notifyWarning("Harvesting %s at %s failed (%s)\n"%(
					rec["title"], rec["accessurl"], str(msg)))
				conn.rollback()

				# on wednesdays, also send out mails with failures
				if datetime.date.today().weekday()==2:
					retval = 1
					sys.stderr.write("While harvesting %s at %s:\n"%(
						rec["title"], rec["accessurl"]))
					sys.stderr.write("Last successful harvest: %s\n\n"%(
						rec["last_inc_harvest"]))

	return retval


if __name__=="__main__":
	from gavo.user import logui
	logui.LoggingUI(base.ui)

	sys.exit(main())
