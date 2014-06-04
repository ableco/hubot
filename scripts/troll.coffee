# Description:
#   None
#
# Dependencies:
#   None
#
# Configuration:
#   None
#

module.exports = (robot) ->
  robot.hear /.*(troll).*/i, (msg) ->
    msg.send 'http://f.cl.ly/items/242d3g1D2v090M3v3O42/Mike-Troll-On-A-Call.png'
    msg.send '@mike stop being a net troll'
