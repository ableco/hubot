lunchOptions = [
  "http://ontheinside.info/wp-content/authors/doug-jaeger/despana02.jpg",
  "http://cdn.mueslifusion.com/wp-content/uploads/2011/05/382229_562747207078546_1208101830_n.jpg",
  "http://midtownlunch.com/downtown-nyc/files/2012/04/parisi-front.jpg",
  "http://www.peperossotogo.com/cms/images/phocagallery/thumbs/phoca_thumb_l_inside%202.jpg",
  "http://www.grandlifehotels.com/wp-content/uploads/2011/09/katz-deli-nyc-ludlow.jpg?9d7bd4",
  "http://www.mightysweet.com/mesohungry/wp-content/uploads/2013/04/01-Parm-Restaurant-NYC.jpg",
  "https://irs0.4sqi.net/img/general/600x600/LR1JCdt_MsJwZVV-U3HTX2cIQHIM_3iFvl5rivb30vg.jpg",
  "http://midtownlunch.com/downtown-nyc/files/2012/02/banh-mi-saigon-outside-500x375.jpg",
  "http://www.we-heart.com/upload-images/tacombiatfondanolita2.jpg",
  "http://midtownlunch.com/downtown-nyc/files/2010/09/DSC01591-500x375.jpg",
  "http://newyork.seriouseats.com/images/2012/10/20121011-taim-opening-exterior.jpg",
  "http://cbsnewyork.files.wordpress.com/2010/08/asia-dog-credit-yelp.jpg",
  "http://memecrunch.com/meme/WKQE/welcome-to-wendys/image.png",
  "http://college-social.com/content/uploads/sites/8/2014/04/chipotle2-1.jpg",
  "http://www.12ozprophet.com/images/news/Mamouns-Falafel.jpeg",
  "http://media-cdn.tripadvisor.com/media/photo-s/03/f9/30/95/percy-s-pizza.jpg",
  "http://newyork.seriouseats.com/images/20081010calexicocart.jpg",
  "http://aloharag-hi-ny-jp.typepad.com/.a/6a0120a6c95938970b014e88d96879970d-800wi",
  "http://midtownlunch.com/downtown-nyc/files/2013/07/P1040480-500x375.jpg"
]

module.exports = (robot) ->
  robot.hear /.*(what are we hating for lunch today).*/i, (msg) ->
    msg.send msg.random lunchOptions