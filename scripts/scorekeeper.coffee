# https://github.com/github/hubot/blob/master/docs/scripting.md

module.exports = (robot) ->
  robot.catchAll (msg) ->
    room = msg.message.room
    sender = msg.message.user.id

    # check if message was the answer to the current question
    question = robot.brain.get("current-trivia-question-#{room}")
    answer = question.answer.replace(/(<([^>]+)>)/ig, '').toLowerCase()
    answer = answer.replace(/[^a-zA-Z0-9\-\s\']/g, ' ')

    if question and msg.message.text.toLowerCase().indexOf(answer) >= 0
      robot.brain.remove("current-trivia-question-#{room}")
      msg.send "Nice job, #{sender}! '#{question.answer.toUpperCase()}' is correct"
      if room == "water-cooler"
        data = JSON.stringify({
          user: sender,
          points: question.value/100
        })
        msg.http("http://disrupto-scorekeeper.herokuapp.com/trivia_answer")
          .post(data) (err, res, body) ->
            console.log body
    else
      last_sender = robot.brain.get("#{room}-last-sender")
      unless sender == last_sender
        data = JSON.stringify({
          user: sender,
          room: room
        })
        msg.http("http://disrupto-scorekeeper.herokuapp.com/comment")
          .post(data) (err, res, body) ->
            console.log body
        robot.brain.set("#{room}-last-sender", sender)
      
    


  robot.hear /(^|\s)([\+|\-]\d+)/i, (msg) ->
    score = msg.match[2]
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

  # a trivia game using the jservice api (http://jservice.io/)
  # example response:
  # [{"id":33724,"answer":"coffer","question":"Type of chest seen here in the Getty collection; those of the Getty trust are quite full","value":500,"airdate":"1998-10-12T12:00:00.000Z","created_at":"2014-02-11T23:05:48.949Z","updated_at":"2014-02-11T23:05:48.949Z","category_id":3942,"category":{"id":3942,"title":"the getty","created_at":"2014-02-11T23:05:48.062Z","updated_at":"2014-02-11T23:05:48.062Z","clue_id":null,"clues_count":5}}]

  robot.respond /quiz me/i, (msg) ->
    msg.http("http://jservice.io/api/random")
      .get() (err, res, body) ->
        question = JSON.parse(body)[0]
        robot.brain.set("current-trivia-question-#{msg.message.room}", question)
        msg.send "[#{question.category.title.toUpperCase()}] For #{question.value/100} point#{if (question.value > 100) then 's' else ''}: #{question.question}..."

  robot.respond /i give up/i, (msg) ->
    question = robot.brain.get("current-trivia-question-#{msg.message.room}")
    robot.brain.remove("current-trivia-question-#{msg.message.room}")
    
    answer = question.answer.replace(/(<([^>]+)>)/ig, '').toLowerCase()
    answer = answer.replace(/[^a-zA-Z0-9\-\s\']/g, ' ')

    reactions = ["LOLZ", "G8", "Great", "Nice job", "That was a tough one", "Thanks for nothing", "You really turchioed that one"]
    reaction = reactions[Math.floor(Math.random() * reactions.length)]

    msg.send "#{reaction}, the answer was '#{answer}'."


# TODO:

# cases in which to skip to new question
# value is null
# question contains the words seen here

# strip out anything in parenthesis in the answer

# 