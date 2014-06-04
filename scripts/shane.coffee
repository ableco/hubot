# Description:
#   None
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot shane me
#
# Author:
#  jakery snakery

shanes = [
  "https://pbs.twimg.com/profile_images/1613918759/headshot-very-small.jpg",
  "http://blogs-images.forbes.com/stevenbertoni/files/2011/09/Forbes-400-Cover1.jpg",
  "http://cdn04.cdn.justjared.com/wp-content/uploads/2011/09/parker-snoop/sean-parker-snoop-dogg-06.jpg",
  "http://nyobetabeat.files.wordpress.com/2011/03/sean-parker-e1300732445771.jpg?w=269&h=300",
  "https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcTWC2Mk1rq2gb3-zEb3VgwlajW5kEC2nV81wrfrpxCXfbhDEODnUw",
  "http://i2.cdn.turner.com/cnn/2011/TECH/social.media/01/24/sean.parker.fiction.mashable/t1larg.sean.parker.gi.jpg",
  "http://i2.wp.com/allthingsd.com/files/2012/10/SeanParker.jpg",
  "http://1.bp.blogspot.com/-Uw1fl5NP06o/UathMqD5OyI/AAAAAAAAAI8/A4y4RX-pQ9s/s1600/Sean_Parker.jpg",
  "http://b-i.forbesimg.com/stevenbertoni/files/2013/12/ParkerChair-233x300.jpg",
  "http://media1.onsugar.com/files/2012/06/23/2/192/1922507/145761370_0.xxxlarge/i/Sean-Parker-Launches-Airtime-Olivia-Munn-Ed-Helms.jpg"
]

module.exports = (robot) ->
  robot.hear /.*(shane me).*/i, (msg) ->
    current_user = msg.message.user.name.toLowerCase()
    return if current_user.indexOf('mike') != -1
    msg.send msg.random shanes
