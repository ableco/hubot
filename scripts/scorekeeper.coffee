# https://github.com/github/hubot/blob/master/docs/scripting.md

module.exports = (robot) ->
  robot.catchAll (msg) ->
    room = msg.message.room
    console.log JSON.stringify(msg.message)
    sender = msg.message.user.id
    robot.brain.set("#{room}-last-sender", sender)
    data = JSON.stringify({
      user: sender,
      room: room
    })
    msg.http("http://disrupto-scorekeeper.herokuapp.com/comment")
      .post(data) (err, res, body) ->
        console.log body


  robot.hear /([\+|\-]\d+)/i, (msg) ->
    score = msg.match[1]
    room = msg.message.room
    score_setter = msg.message.user.id
    last_sender = robot.brain.get("#{room}-last-sender")
    data = JSON.stringify({
      user: last_sender,
      score: score,
      scorer: score_setter
    })
    msg.http("http://disrupto-scorekeeper.herokuapp.com/plus_and_minus")
      .post(data) (err, res, body) ->
        console.log body

