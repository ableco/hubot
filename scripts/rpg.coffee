class Character
  constructor: (character_json) ->
    @character = character_json
    @attribute_string = "[Level: #{@character.level}, EXP: #{@character.experience}, HP: #{@character.hitpoints_remaining}/#{@character.hitpoints}, Strength: #{@character.strength}, Vitality: #{@character.vitality}, Defense: #{@character.vitality}, Dexterity: #{@character.dexterity}, Intelligence: #{@character.intelligence}, Wisdom: #{@character.wisdom}, Ego: #{@character.ego}, Perception: #{@character.perception}, Charisma: #{@character.charisma}, Luck: #{@character.luck}]"

  print_who_am_i: (msg) ->
    msg.send "You are #{msg.message.user.id} #{@character.race_article} #{@character.race} #{@character.character_class} #{@attribute_string}"

  print_reroll: (msg) ->
    msg.send "You are now #{msg.message.user.id} #{@character.race_article} #{@character.race} #{@character.character_class} #{@attribute_string}"

class Monster
  constructor: (msg, robot) ->
    # create monster

class Die
  constructor: (sides) ->
    @sides = sides

  roll: ->
    (Math.floor(Math.random() * @sides) + 1)

module.exports = (robot) ->
  # provides the user with information about their character
  robot.hear /who am i?/i, (msg) ->
    character = new Character(JSON.parse(robot.brain.get("character-#{msg.message.user.id}")))
    character.print_who_am_i(msg)

  # regenerates the user's character
  robot.hear /reroll me/i, (msg) ->
    races = ["Dwarf", "Elf", "Gnome", "Orc", "Human", "Goblin", "Troll", "Ogre", "Minotaur", "Halfling", "Kobold", "Giant"]
    classes = ["Wizard", "Hunter", "Warrior"]

    if msg.message.user.id == "mike"
      race = "Troll"
      character_class = "Wizard"
    else
      race = races[Math.floor(Math.random() * races.length)]
      character_class = classes[Math.floor(Math.random() * classes.length)]
    
    race_article = if (race in ["Elf", "Orc", "Ogre"]) then "an" else "a"

    die = new Die(15)

    strength = die.roll()
    vitality = die.roll()
    defense = die.roll()
    dexterity = die.roll()
    intelligence = die.roll()
    wisdom = die.roll()
    ego = die.roll()
    perception = die.roll()
    charisma = die.roll()
    luck = die.roll()

    hp = switch
      when character_class == "Wizard" then 20
      when character_class == "Hunter" then 30
      when character_class == "Warrior" then 40

    hp = hp + vitality

    character_json = {
      level: 1,
      strength: strength,
      vitality: vitality,
      defense: defense,
      dexterity: dexterity,
      intelligence: intelligence,
      wisdom: wisdom,
      ego: ego,
      perception: perception,
      charisma: charisma,
      luck: luck,
      experience: 1,
      hitpoints: hp,
      hitpoints_remaining: hp,
      race: race,
      race_article: race_article,
      character_class: character_class
    }

    robot.brain.set("character-#{msg.message.user.id}", JSON.stringify(character_json))

    character = new Character(character_json)
    character.print_reroll(msg)
