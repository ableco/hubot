module.exports = (robot) ->

  robot.hear /^([\+|\-]\d+)/, (msg) ->
    score = msg.match[0]
    msg.reply "dsfsfsdfs"
    msg.reply msg
    msg.http("http://disrupto-scorekeeper.herokuapp.com/update")
      .patch({"ben" : score}) (err, res, body) ->
        msg.send "ok"