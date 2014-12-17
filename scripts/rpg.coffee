class Monster
  constructor: (msg, robot) ->
    # create monster

class Die
  constructor: (sides) ->
    @sides = sides

  roll: ->
    (Math.floor(Math.random() * sides) + 1)

module.exports = (robot) ->
  # provides the user with information about their character
  robot.hear /who am i?/i, (msg) ->
    character = JSON.parse(robot.brain.get("character-#{msg.message.user.id}"))
    msg.send "You are #{msg.message.user.id} #{character.race_article} #{character.race} #{character.class} [EXP: #{character.experience}, HP: #{character.hitpoints_remaining}/#{character.hitpoints}, Strength: #{character.strength}, Dexterity: #{character.dexterity}, Intelligence: #{character.intelligence}, Wisdom: #{character.wisdom}, Charisma: #{character.charisma}]"

  # regenerates the user's character
  robot.hear /reroll me/i, (msg) ->
    races = ["Dwarf", "Elf", "Gnome", "Orc", "Human", "Goblin", "Troll", "Ogre", "Minotaur"]
    classes = ["Assassin", "Druid", "Paladin", "Sorcerer", "Thief", "Rogue", "Wizard", "Mage", "Ranger", "Cleric", "Monk", "Shaman", "Warrior"]

    race = races[Math.floor(Math.random() * races.length)]
    race_article = if (race in ["Elf", "Orc", "Ogre"]) then "an" else "a"

    die = new Die(15)

    character = {
      strength: die.roll(),
      dexterity: die.roll(),
      intelligence: die.roll(),
      wisdom: die.roll(),
      charisma: die.roll(),
      experience: 1,
      hitpoints: 100,
      hitpoints_remaining: 100,
      race: race,
      race_article: race_article,
      class: classes[Math.floor(Math.random() * classes.length)]
    }

    robot.brain.set("character-#{msg.message.user.id}", JSON.stringify(character))

    msg.send "You are now #{character.race_article} #{character.race} #{character.class} [EXP: #{character.experience}, HP: #{character.hitpoints_remaining}/#{character.hitpoints}, Strength: #{character.strength}, Dexterity: #{character.dexterity}, Intelligence: #{character.intelligence}, Wisdom: #{character.wisdom}, Charisma: #{character.charisma}]"
