class Character 
  constructor: (msg, robot) ->
    @races = ["Dwarf", "Elf", "Gnome", "Orc", "Human"]
    @classes = ["Assassin", "Druid", "Paladin", "Sorcerer", "Thief", "Rogue", "Wizard", "Mage", "Ranger", "Cleric", "Monk", "Shaman", "Warrior"]

    character = {
      strength: (Math.floor(Math.random() * 13) + 1),
      dexterity: (Math.floor(Math.random() * 13) + 1),
      intelligence: (Math.floor(Math.random() * 13) + 1),
      wisdom: (Math.floor(Math.random() * 13) + 1),
      charisma: (Math.floor(Math.random() * 13) + 1),
      race: @races[Math.floor(Math.random() * @races.length)],
      class: @classes[Math.floor(Math.random() * @classes.length)]
    }

    robot.brain.set("character-#{msg.message.user.id}", JSON.stringify(character))

    msg.send "You are now a #{character.race} #{character.class} [Strength: #{character.strength}, Dexterity: #{character.dexterity}, Intelligence: #{character.intelligence}, Wisdom: #{character.wisdom}, Charisma: #{character.charisma}]"


class Monster
  constructor: (msg, robot) ->
    # create monster

module.exports = (robot) ->
  robot.hear /who am i?/i, (msg) ->
    character = JSON.parse(robot.brain.get("character-#{msg.message.user.id}"))
    msg.send "You are #{msg.message.user.id} a #{character.race} #{character.class} [String: #{character.strength}, Dexterity: #{character.dexterity}, Inteligence: #{character.intelligence}, Wisom: #{character.wisdom}, Charisma: #{character.charisma}]."

  robot.hear /reroll me/i, (msg) ->
    new Character(msg, robot)
