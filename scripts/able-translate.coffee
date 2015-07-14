module.exports = (robot) ->
  robot.brain.data.autotranslate ?= false

  robot.hear /(.*)/i, (msg) ->
    if robot.brain.data.autotranslate
      msg.http('http://louie-translate.herokuapp.com/translate.json')
        .query(phrase: msg.match[1])
        .get() (err, res, body) ->
          msg.send(body)

  robot.respond /translate (auto|start|on|yes)/i, (msg) ->
    robot.brain.data.autotranslate = true
    msg.send 'Translation started!'

  robot.respond /translate (stop|off|no)/i, (msg) ->
    robot.brain.data.autotranslate = false
    msg.send 'Translation stopped!'
