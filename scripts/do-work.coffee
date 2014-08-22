imageMe = (msg, query, callback) ->
  q = v: '1.0', rsz: '8', q: query, safe: 'active'
  msg.http('http://ajax.googleapis.com/ajax/services/search/images')
    .query(q)
    .get() (err, res, body) ->
      images = JSON.parse(body)
      images = images.responseData?.results
      if images?.length > 0
        image  = msg.random images
        callback "#{image.unescapedUrl}#.png"

module.exports = (robot) ->
  robot.respond /do work/i, (msg) ->
    imageMe msg, 'no', (url) ->
      msg.send url
