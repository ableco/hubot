module.exports = (robot) ->
  game = new Game(robot)
  robot.hear /!trivia/, (resp) ->
    game.askQuestion(resp)

  robot.hear /!skip/, (resp) ->
    game.skipQuestion(resp)

  robot.hear /!a(nswer)? (.*)/, (resp) ->
    game.answerQuestion(resp, resp.match[2])
  
  robot.hear /!score (.*)/i, (resp) ->
    game.checkScore(resp, resp.match[1].toLowerCase().trim())