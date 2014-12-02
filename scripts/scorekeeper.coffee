# https://github.com/github/hubot/blob/master/docs/scripting.md

module.exports = (robot) ->
  robot.catchAll (msg) ->
    room = msg.message.room
    sender = msg.message.user.name
    robot.brain.set("#{room}-last-sender", sender)

  robot.hear /([\+|\-]\d+)/i, (msg) ->
    score = msg.match[1]
    room = msg.message.room
    score_setter = msg.message.user.name
    last_sender = robot.brain.get("#{room}-last-sender")
    #msg.reply msg.match[1]
    # score = msg.match[0]
    # msg.reply "dsfsfsdfs"
    # msg.reply msg
    msg.http("http://disrupto-scorekeeper.herokuapp.com/update")
      .post({"user" : last_sender, "score" : score, "scorer" : score_setter}) (err, res, body) ->
        # whatever