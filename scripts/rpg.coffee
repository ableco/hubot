class Character
  constructor: (character_json) ->
    @character = character_json
    @attribute_string = "[Level: #{@character.level}, EXP: #{@character.experience}, HP: #{@character.hitpoints_remaining}/#{@character.hitpoints}, Strength: #{@character.strength}, Vitality: #{@character.vitality}, Defense: #{@character.vitality}, Dexterity: #{@character.dexterity}, Intelligence: #{@character.intelligence}, Wisdom: #{@character.wisdom}, Ego: #{@character.ego}, Perception: #{@character.perception}, Charisma: #{@character.charisma}, Luck: #{@character.luck}]"

  dead: ->
    @character.hitpoints_remaining <= 0

  print_who_am_i: (msg) ->
    msg.send "You are #{msg.message.user.id} #{@character.race_article} #{@character.race} #{@character.character_class} #{@attribute_string}"

  print_reroll: (msg) ->
    msg.send "You are now #{msg.message.user.id} #{@character.race_article} #{@character.race} #{@character.character_class} #{@attribute_string}"

  attack: (msg, robot, name_of_person_being_attacked) ->
    @attacked_character = JSON.parse(robot.brain.get("character-#{name_of_person_being_attacked}"))

    die = new Die

    base_attack = switch @character.character_class
      when "Wizard" then @character.intelligence
      when "Hunter" then @character.dexterity
      when "Warrior" then @character.strength
    base_attack_die_roll = die.roll(20)
    attack_score = base_attack + base_attack_die_roll
    defense_score = die.roll(@attacked_character.luck) + die.roll(@attacked_character.defense)

    msg.send "#{msg.message.user.id} (#{attack_score}) attacked #{name_of_person_being_attacked} (#{defense_score})"

    if base_attack_die_roll == 20 # critical strike if 20 is rolled
      damage = 3 + die.roll(3) 
    else if base_attack_die_roll == 1 # auto miss if 1 is rolled
      damage = 0
    else if attack_score > defense_score
      damage = die.roll(3)
    else
      damage = 0

    if damage > 0
      @character.experience += 1
      @attacked_character.hitpoints_remaining -= damage

      if @attacked_character.hitpoints_remaining < 0 # killed
        @character.experience += 5
        msg.send "#{if base_attack_die_roll == 20 then 'CRITICAL STRIKE' else 'SUCCESS'}! #{msg.message.user.id} killed #{name_of_person_being_attacked} by doing #{damage} damage. RIP."
      else
        @character.experience += 1
        msg.send "#{if base_attack_die_roll == 20 then 'CRITICAL STRIKE' else 'SUCCESS'}! #{msg.message.user.id} did #{damage} damage to #{name_of_person_being_attacked} who now has #{@attacked_character.hitpoints_remaining} hitpoints remaining."

      robot.brain.set("character-#{msg.message.user.id}", JSON.stringify(@character))
      robot.brain.set("character-#{name_of_person_being_attacked}", JSON.stringify(@attacked_character))
    else
      msg.send "Missed!"

class Monster
  constructor: (msg, robot) ->
    # create monster

class Die
  roll: (sides) ->
    (Math.floor(Math.random() * sides) + 1)

module.exports = (robot) ->
  # provides the user with information about their character
  robot.hear /who am i?/i, (msg) ->
    character = new Character(JSON.parse(robot.brain.get("character-#{msg.message.user.id}")))
    if character.dead == true
      msg.send "You are nobody. You are dead. Reroll to play again."
    else
      character.print_who_am_i(msg)

  robot.hear /attack (\w+)/i, (msg) ->
    person_being_attacked = msg.match[1]
    character = new Character(JSON.parse(robot.brain.get("character-#{msg.message.user.id}")))
    if character.dead == true
      msg.send "You are dead. You can't attack anybody. Reroll to play again."
    else
      character.attack(msg, robot, person_being_attacked)

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

    die = new Die

    strength = die.roll(15)
    vitality = die.roll(15)
    defense = die.roll(15)
    dexterity = die.roll(15)
    intelligence = die.roll(15)
    wisdom = die.roll(15)
    ego = die.roll(15)
    perception = die.roll(15)
    charisma = die.roll(15)
    luck = die.roll(15)

    if character_class == "Wizard"
      hp = 20 + vitality
      intelligence = 7 if intelligence < 7
      intelligence += die.roll(6)
    else if character_class == "Hunter"
      hp = 30 + vitality
      dexterity = 7 if dexterity < 7
      dexterity += die.roll(6)
    else if character_class == "Warrior"
      hp = 40 + vitality
      strength = 7 if strength < 7
      strength += die.roll(6)

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
