module.exports = (robot) ->
  # robot.catchAll (msg) ->
  #   room = msg.message.room
  #   sender = msg.message.user.id
  #   last_sender = robot.brain.get("#{room}-last-sender")
  #   unless sender == last_sender
  #     data = JSON.stringify({
  #       user: sender,
  #       room: room
  #     })
  #     msg.http("http://disrupto-scorekeeper.herokuapp.com/comment")
  #       .post(data) (err, res, body) ->
  #         console.log body
  #     robot.brain.set("#{room}-last-sender", sender)
    
    


  # robot.hear /(^|\s)([\+|\-]\d+)/i, (msg) ->
  #   score = msg.match[2]
  #   room = msg.message.room
  #   score_setter = msg.message.user.id
  #   last_sender = robot.brain.get("#{room}-last-sender")
  #   data = JSON.stringify({
  #     user: last_sender,
  #     score: score,
  #     scorer: score_setter
  #   })
  #   msg.http("http://disrupto-scorekeeper.herokuapp.com/plus_and_minus")
  #     .post(data) (err, res, body) ->
  #       console.log body

  robot.respond /quiz me/i, (msg) ->
    msg.http("http://jservice.io/api/random")
      .get() (err, res, body) ->
        msg.send JSON.parse(body)[0].question