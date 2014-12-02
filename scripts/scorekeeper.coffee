# https://github.com/github/hubot/blob/master/docs/scripting.md

module.exports = (robot) ->

  robot.hear /([\+|\-]\d+)/i, (msg) ->
    msg.send "WHAT"
    # score = msg.match[0]
    # msg.reply "dsfsfsdfs"
    # msg.reply msg
    # msg.http("http://disrupto-scorekeeper.herokuapp.com/update")
    #   .patch({"ben" : score}) (err, res, body) ->
    #     msg.send "ok"