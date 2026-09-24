"""
A manual hack to pull new registries into the registries table and
throw deleted ones out.

This is basically like GloTS' retrieveTAPServices.  Can we abstract something
and put it into DaCHS?
"""

import os
import shutil
import sys
import pprint
import urllib.request

from gavo import api
from gavo import base
from gavo import utils

harvestRegistries, _ = api.loadPythonModule(
	"harvestRegistries", relativeTo=__file__)

RDID = "rr/q"
RD = api.getRD(RDID)
ROFR_OAI_ENDPOINT = "http://rofr.ivoa.net/oai"

api.setUserAgent(f"KazVO-RegTAP-harvester DaCHS/{api.__version__}")


AUTHORITY_OVERRIDES = [
# fix the following pairs of registries and authorities
# This is when rogue registries start claiming authorities they
# shouldn't claim.  As long as there is something here, we emit
# a warning to the logs, since this needs to be fixed upstream.
# These are tuples of (authority, registry ivoid)
('jive.eu', 'ivo://jive.eu/__system__/services/registry'),
]

# Always harvest our own publishing registry over loopback.  The public
# reverse proxy can lag behind a just-published record, whereas operators
# expect --force-local to make a new KazVO publication searchable at once.
localPort = int(base.getConfig("web", "serverPort"))
localOAIURL = "http://127.0.0.1{}".format(
	"" if localPort==80 else ":{}".format(localPort)) + "/oai.xml"
LOCAL_ACCESSURL_OVERRIDES = {
	'ivo://fai.kz/__system__/services/registry': localOAIURL,
}

def updateRegistries(rofrRegistries):
	"""updates the registries table in the rr schema from the
	records in rofrRegistries.

	The records contain ivoid, accessurl, and title fields as for
	the registries table.

	This comprises inserting records so far unknown and removing those
	no longer available.
	"""
	newIds = []
	regTD = RD.getById("registries")
	with api.getWritableAdminConn() as conn:
		cursor = conn.cursor()

		regTable = api.TableForDef(regTD, connection=conn)
		authTable = api.TableForDef(RD.getById("authorities"),
			connection=conn, create=True)

		knownIds = set(r["ivoid"]
			for r in regTable.iterQuery(
				[regTD.getColumnByName("ivoid")], ""))

		# push collected data into the database
		for rec in rofrRegistries:
			if rec["ivoid"] in LOCAL_ACCESSURL_OVERRIDES:
				rec = dict(rec)
				rec["accessurl"] = LOCAL_ACCESSURL_OVERRIDES[rec["ivoid"]]

			# first stuff any new authorities into the appropriate table
			# (this works ok because of the dropPolicy)
			for ma in rec["authorities"]:
				authTable.addRow({"ivoid": rec["ivoid"],
					"managed_authority": ma})

			# then feed any new records, update title and accessurl for others
			id = rec["ivoid"]
			if id in knownIds:
				# should I have some abstraction for this?
				cursor.execute("UPDATE rr.registries"
					" SET accessurl=%(accessurl)s, title=%(title)s"
					" WHERE ivoid=%(ivoid)s", rec)
				knownIds.remove(id)
			else:
				rec.update({
					"last_full_harvest": None,
					"last_inc_harvest": None})
				regTable.addRow(rec)
				newIds.append(id)

		if AUTHORITY_OVERRIDES:
			base.ui.notifyWarning("AUTHORITY_OVERRIDES defined in harvestRofR."
				"  Please have bad registry records fixed and remove the"
				" overrides.")
			for rec in AUTHORITY_OVERRIDES:
				authTable.addRow(
					dict(zip(["managed_authority", "ivoid"], rec)))

		# All that's left in knownIds now are registries no longer registred.
		# We remove them, and by foreign key constraints, all data for them should
		# vanish, too.
		# We need to remove the directories containing the downloaded files, too,
		# since otherwise those records would come back on a re-import as
		# abandoned records.
		for id in knownIds:
			conn.execute("DELETE FROM rr.registries WHERE ivoid=%(ivoId)s",
				{"ivoId": id})
			shutil.rmtree(harvestRegistries.getDirnameFor(id))


class _OAIEndpointExtractor(utils.StartEndHandler):
	def _initialize(self):
		self.records = []
		self.inRegCap = False

	def _start_capability(self, name, attrs):
		self.inRegCap = (
			attrs.get("standardID", "").lower()=="ivo://ivoa.net/std/registry")
	
	def _end_capability(self, name, attrs, content):
		self.inRegCap = False

	def _start_interface(self, name, attrs):
		self.curIntfType = attrs.get("xsi:type")
		self.curIntfVersion = attrs.get("version", "1.0")
	
	def _end_interface(self, name, attrs, content):
		del self.curIntfType
		del self.curIntfVersion

	def _start_Resource(self, name, attrs):
		self.curTitle = None
		self.curIVORN = None
		self.curOAIURL = None
		self.curAuths = []
	
	def _end_Resource(self, name, attrs, content):
		if attrs.get("status")=="active":
			if self.curOAIURL:
				self.records.append(
					{"title": self.curTitle, "ivoid": self.curIVORN,
						"accessurl": self.curOAIURL.strip(),
						"authorities": self.curAuths})
		del self.curTitle
		del self.curIVORN
		del self.curOAIURL
		del self.curAuths

	def _end_managedAuthority(self, name, attrs, content):
		self.curAuths.append(content.lower())

	def _end_title(self, name, attrs, content):
		self.curTitle = content

	def _end_identifier(self, name, attrs, content):
		self.curIVORN = content.lower()

	def _end_accessURL(self, name, attrs, content):
		if not self.inRegCap:
			return
		if self.curIntfType=="vg:OAIHTTP" and self.curIntfVersion=="1.0":
			self.curOAIURL = content


def getRegistryRecords():
	if os.path.exists("ROFR_DEBUG.xml"):
		api.ui.notifyWarning("harvestRofR USING CACHED RESULT!\n")
		inF = open("ROFR_DEBUG.xml")
	else:
		inF = urllib.request.urlopen(ROFR_OAI_ENDPOINT
			+"?verb=ListRecords&metadataPrefix=ivo_vor&set=ivo_publishers",
			timeout=60)
	parser = _OAIEndpointExtractor()
	parser.parse(inF)
	inF.close()
	return parser.records


if __name__=="__main__":
	from gavo.user import logui
	logui.LoggingUI(base.ui)
	records = getRegistryRecords()
	updateRegistries(records)
