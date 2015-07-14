module.exports = (robot) ->
  robot.hear /translate (.*)/i, (msg) ->
    msg.send('I hear you, wait up')
    msg.http('http://louie-translate.herokuapp.com/translate.json')
      .query(phrase: msg.match[0])
      .get() (err, res, body) ->
        msg.send(body)
