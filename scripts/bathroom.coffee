module.exports = (robot) ->
  robot.respond /bathroom status/i, (msg) ->
    msg.http('http://bathroom-status.herokuapp.com/index.json')
      .get() (err, res, body) ->
        msg.send(body)
