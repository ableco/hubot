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

  # a trivia game using the jservice api (http://jservice.io/)
  # example response:
  # [{"id":33724,"answer":"coffer","question":"Type of chest seen here in the Getty collection; those of the Getty trust are quite full","value":500,"airdate":"1998-10-12T12:00:00.000Z","created_at":"2014-02-11T23:05:48.949Z","updated_at":"2014-02-11T23:05:48.949Z","category_id":3942,"category":{"id":3942,"title":"the getty","created_at":"2014-02-11T23:05:48.062Z","updated_at":"2014-02-11T23:05:48.062Z","clue_id":null,"clues_count":5}}]
  
  robot.respond /quiz me/i, (msg) ->
    msg.http("http://jservice.io/api/random")
      .get() (err, res, body) ->
        question = JSON.parse(body)[0]
        robot.brain.set("current-trivia-question", question)
    
    q = robot.brain.get("current-trivia-question")

    console.log q.answer

    msg.send "[#{q.category.title}] For #{q.value/100} points: #{y.question}"