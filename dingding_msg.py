#coding=utf-8
import hashlib
import urllib2
import json
import re
import logging

class Tools(object):

	def __init__(self):
		pass


	def md5hex(self, string):
		m = hashlib.md5()
		m.update(string)
		return m.hexdigest()


	def get_json(self, _message):
		import json
		response = object()
		if _message != "" and _message is not None:
			position = _message.index('{"')
			msg = _message[position:len(_message)]
			response = json.loads(msg)

		return response

	def get_type(self, message):
		m = message
		message_type = ''
		if m is None:
			return message_type
		if m.find("DiggMessage") >= 0:
			message_type = 'DiggMessage'
		elif m.find("ChatMessage") >= 0:
			message_type = 'ChatMessage'
		elif m.find("RoomMessage") >= 0:
			message_type = 'RoomMessage'
		elif m.find("ControlMessage") >= 0:
			message_type = 'ControlMessage'
		elif m.find("MemberMessage") >= 0:
			message_type = 'MemberMessage'
		elif m.find("GiftMessage") >= 0:
			message_type = 'GiftMessage'
		elif m.find("SocialMessage") >= 0:
			message_type = 'SocialMessage'
		elif m.find("RoomstartMessage") >= 0:
			message_type = 'RoomstartMessage'
		elif m.find("SystemMessage") >= 0:
			message_type = 'SystemMessage'
		elif m.find("HELLOB") >= 0:
			message_type = 'HelloMessage'
		elif m.find('ping') >= 0:
			message_type = 'PingMessage'
		else:
			logging.info(m)
			message_type = 'Unkown'
		return message_type

	def sendMsgToDingDing(self, msg, channelid):
		api = "https://infosys.byted.org/ratak/dingtalk/channels/"+str(channelid)+"/messages/"
		text = msg
		import base64
		username = "20"
		password = "75331FDAAB5C4C18A36E005F3142FE2A"
		bodydata = {'channel_id':channelid,'type':'text','content':{'content': text}}
		# print bodydata
		request = urllib2.Request(api)
		request.add_header("Content-Type", "application/json")
		base64string = base64.encodestring('%s:%s' % (username, password)).replace('\n', '')
		request.add_header("Authorization", "Basic %s" % base64string)
		result = urllib2.urlopen(request, json.dumps(bodydata))
		ret = json.load(result)
		# print ret


	def assert_equal(self, real_data, expect):
		if real_data != expect:
			return False
		return True

	def get(self, url):
		return urllib2.urlopen(url)

	def getErrmsgFromConsoleText(self, build_url):
		"""
    	console_text_url sample: http://ci.byted.org/job/TT_iOS_EverPhoto_Release/161/
    	"""
		print "getErrmsgFromConsoleText", build_url
		if len(build_url) == 0:
			return ""
		ret = ""
		text = self.get("%s/consoleText" % build_url).read()
		lines = text.split("\n")
		for line in lines:
			if line.lower().find("finished:") != -1:
				ret += line
		ret = ret.replace("\"", "'").replace("“", "'")
		return ret if len(ret) > 0 else "没找到原始错误日志， 详细参看%s/consoleText" % build_url


	def getCIJobJson(self, build_url):
		"""
		ci_job_url sample: http://ci.byted.org/view/live/job/live_iOS_inhouse_dailybuild_backup/36/
		"""
		print "getCIJobJson", build_url
		if len(build_url) == 0:
			return ""
		ret = ""
		text = self.get("%s/api/json" % build_url).read()
		return json.loads(text)


if __name__ == "__main__":
	t = Tools()
	all_the_text = open('/Users/wangshuai/work/AndroidShell/msg.log').read( )
	t.sendMsgToDingDing(all_the_text, 356)





