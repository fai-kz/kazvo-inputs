"""
A custom service turning VOResource into a landing page-type HTML document.

We are using this to produce identifiers for b2find.
"""

import functools
import os

from lxml import etree as lxmletree

from gavo import base
from gavo import utils

irkpage, _ = utils.loadPythonModule(
	os.path.join(base.getConfig("inputsDir"), "rr", "res", "irkpage"))


@functools.cache
def get_stylesheet():
	with open(os.path.join(base.getConfig("inputsDir"),
			"voidoi", "res", "vor-to-landing.xslt"), encoding="utf-8") as f:
		return lxmletree.XSLT(lxmletree.parse(f))


class MainPage(irkpage.MainPage):
	def makeResponse(self, request, oaiRec):
		request.setHeader("content-type", "text/html; charset=utf-8")
		srcXML = irkpage.mungeOAIXML(oaiRec).render()
		return str(get_stylesheet()(lxmletree.XML(srcXML),
			favicon="'/rr/q/lp/static/ivoa-favicon.png'")).encode("utf-8")
