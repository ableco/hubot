module.exports = (robot) ->

  robot.respond /^([\+|\-]\d+)/, (msg) ->
    score = msg.match[0]
    msg.http("http://disrupto-scorekeeper.herokuapp.com/update")
      .patch({"ben" : score})