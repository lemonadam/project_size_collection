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

	
#需要隐藏的方法


if __name__ == "__main__":
	t = Tools()
	all_the_text = open('/Users/wangshuai/work/AndroidShell/msg.log').read( )
	t.sendMsgToDingDing(all_the_text, 356)





