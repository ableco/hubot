# https://github.com/github/hubot/blob/master/docs/scripting.md

module.exports = (robot) ->
  robot.catchAll (msg) ->
    room = msg.message.room
    console.log JSON.stringify(msg.message)
    sender = msg.message.user.name
    robot.brain.set("#{room}-last-sender", sender)

  # not working right now
  robot.respond /score us/i, (msg) ->
    msg.http("http://disrupto-scorekeeper.herokuapp.com/")
      .get() (err, res, body) ->
        msg.send body

  robot.hear /([\+|\-]\d+)/i, (msg) ->
    score = msg.match[1]
    room = msg.message.room
    score_setter = msg.message.user.name
    last_sender = robot.brain.get("#{room}-last-sender")
    data = JSON.stringify({
      user: last_sender,
      score: score,
      scorer: score_setter
    })
    msg.http("http://disrupto-scorekeeper.herokuapp.com/update")
      .post(data) (err, res, body) ->
        console.log body

