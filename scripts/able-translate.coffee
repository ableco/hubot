# Description:
#   [Translate] Hubot learns to speak multiple languages!
#
# Dependencies:
#   redis-brain
#
# Commands:
#   hubot translate reset
#   hubot translate on
#   hubot translate off
#
# Author:
#   rickyc

module.exports = (robot) ->
  # list of rooms with translate parameter
  robot.brain.data.autotranslate ?= {}

  robot.respond /translate reset/i, (msg) ->
    robot.brain.data.autotranslate = {}

  robot.respond /translate (auto|start|on|yes)/i, (msg) ->
    robot.brain.data.autotranslate[msg.message.room] = true
    msg.send 'Translation started!'

  robot.respond /translate (stop|off|no)/i, (msg) ->
    robot.brain.data.autotranslate[msg.message.room] = false
    msg.send 'Translation stopped!'

  robot.hear /(.*)/i, (msg) ->
    if robot.brain.data.autotranslate[msg.message.room]
      msg.http('http://louie-translate.herokuapp.com/translate.json')
        .query(phrase: msg.match[1])
        .get() (err, res, body) ->
          msg.send(body)

  robot.respond /translate help/i, (msg) ->
    msg.send """
     hubot translate reset
     hubot translate on
     hubot translate off
   """
