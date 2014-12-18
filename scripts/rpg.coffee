class Character
  constructor: (character_json) ->
    @character = character_json
    @attribute_string = "[Level: #{@character.level}, EXP: #{@character.experience}, HP: #{@character.hitpoints_remaining}/#{@character.hitpoints}, Strength: #{@character.strength}, Vitality: #{@character.vitality}, Defense: #{@character.vitality}, Dexterity: #{@character.dexterity}, Intelligence: #{@character.intelligence}, Wisdom: #{@character.wisdom}, Ego: #{@character.ego}, Perception: #{@character.perception}, Charisma: #{@character.charisma}, Luck: #{@character.luck}]"

  dead: ->
    @character.hitpoints_remaining <= 0

  print_show: (msg, name) ->
    msg.send "#{name} is #{@character.race_article} #{@character.race} #{@character.character_class} #{@attribute_string}"

  print_who_am_i: (msg) ->
    msg.send "You are #{@character.race_article} #{@character.race} #{@character.character_class} named #{msg.message.user.id} #{@attribute_string}"

  print_reroll: (msg) ->
    msg.send "You are now #{@character.race_article} #{@character.race} #{@character.character_class} named #{msg.message.user.id} #{@attribute_string}"

  attack: (msg, robot, name_of_person_being_attacked) ->
    attacking_monster = name_of_person_being_attacked == "monster"
    @attacked_character = JSON.parse(robot.brain.get("character-#{name_of_person_being_attacked}"))

    if attacking_monster == true
      name_of_person_being_attacked = "the #{@attacked_character.monster_type}"

    if @attacked_character.hitpoints_remaining <= 0
      msg.send "You animal. #{name_of_person_being_attacked} is already dead!"
    else
      die = new Die
      base_attack = switch @character.character_class
        when "Wizard" then @character.intelligence
        when "Hunter" then @character.dexterity
        when "Warrior" then @character.strength

      base_attack_die_roll = die.roll(7 + @character.level)
      attack_score = base_attack + base_attack_die_roll
      defense_score = die.roll(@attacked_character.luck) + die.roll(@attacked_character.defense) + die.roll(@attacked_character.perception)

      msg.send "#{msg.message.user.id} (#{attack_score}) attacked #{name_of_person_being_attacked} (#{defense_score})"

      if base_attack_die_roll == 15 # critical strike if 20 is rolled TODO: the odds of this decrease as level goes up...
        damage = base_attack + die.roll(5) 
      else if base_attack_die_roll == 1 # auto miss if 1 is rolled
        damage = 0
      else if attack_score > defense_score
        damage = die.roll(base_attack)
      else
        damage = 0

      if damage > 0
        @attacked_character.hitpoints_remaining -= damage

        if @attacked_character.hitpoints_remaining <= 0 # killed
          experience = @attacked_character.experience
          @character.experience += experience
          @character.hitpoints_remaining += (die.roll(@character.vitality + @character.level))
          if @character.hitpoints_remaining > @character.hitpoints
            @character.hitpoints_remaining = @character.hitpoints
          msg.send "#{if base_attack_die_roll == 20 then 'CRITICAL STRIKE' else 'SUCCESS'}! #{msg.message.user.id} (+#{experience} exp) killed #{name_of_person_being_attacked} by doing #{damage} damage. Bravo!"
        else
          @character.experience += 1
          msg.send "#{if base_attack_die_roll == 20 then 'CRITICAL STRIKE' else 'SUCCESS'}! #{msg.message.user.id} (+1 exp) did #{damage} damage to #{name_of_person_being_attacked} who now has #{@attacked_character.hitpoints_remaining} hitpoints remaining."
      else
        if (die.roll(@attacked_character.perception) + die.roll(@attacked_character.luck)) >= (die.roll(@character.defense) + die.roll(@character.luck))
          if attacking_monster == true
            damage = die.roll(@attacked_character.strength)
            @character.hitpoints_remaining -= damage
            msg.send "#{name_of_person_being_attacked} dodged #{msg.message.user.id}'s attack and countered to do #{damage} damage!"  
          else
            base_counterattack = switch @attacked_character.character_class
              when "Wizard" then @attacked_character.intelligence
              when "Hunter" then @attacked_character.dexterity
              when "Warrior" then @attacked_character.strength
            damage = die.roll(base_counterattack)
            @attacked_character.experience += 3
            @character.hitpoints_remaining -= damage
            msg.send "#{name_of_person_being_attacked} (+3 exp) dodged #{msg.message.user.id}'s attack and countered to do #{damage} damage!"

          if @character.hitpoints_remaining <= 0
            if attacking_monster == true
              msg.send "#{msg.message.user.id} has died. Good riddance."
            else
              @attacked_character.experience += 5
              msg.send "#{msg.message.user.id} has died. Nice Job! (+5 exp for #{name_of_person_being_attacked})!"
        else
          msg.send "#{name_of_person_being_attacked} dodged #{msg.message.user.id}'s attack!"

      # save all character info after attack
      level = @character.level
      new_level = Math.floor(@character.experience / 100) + 1
      
      if new_level > level
        msg.send "#{msg.message.user.id} has leveled up to level #{new_level}!"
      @character.level = new_level
      robot.brain.set("character-#{msg.message.user.id}", JSON.stringify(@character))

      if attacking_monster == true
        robot.brain.set("character-monster", JSON.stringify(@attacked_character))
      else
        robot.brain.set("character-#{name_of_person_being_attacked}", JSON.stringify(@attacked_character))

class Monster
  constructor: (monster_json) ->
    @character = monster_json
    @attribute_string = "[EXP: #{@character.experience}, HP: #{@character.hitpoints_remaining}/#{@character.hitpoints}, Strength: #{@character.strength}, Vitality: #{@character.vitality}, Defense: #{@character.vitality}, Dexterity: #{@character.dexterity}, Intelligence: #{@character.intelligence}, Wisdom: #{@character.wisdom}, Ego: #{@character.ego}, Perception: #{@character.perception}, Charisma: #{@character.charisma}, Luck: #{@character.luck}]"

  print_spawn: (msg) ->
    msg.send "A #{@character.monster_type} has appeared! #{@attribute_string}"

  print_show: (msg) ->
    msg.send "There is a #{@character.monster_type} here! #{@attribute_string}"

class Die
  roll: (sides) ->
    (Math.floor(Math.random() * sides) + 1)

module.exports = (robot) ->
  # provides the user with information about their character
  robot.hear /who am i/i, (msg) ->
    character = new Character(JSON.parse(robot.brain.get("character-#{msg.message.user.id}")))
    if character.dead() == true
      msg.send "You are nobody. You are dead. Reroll to play again."
    else
      character.print_who_am_i(msg)

  robot.hear /show me (\w+)/i, (msg) ->
    person_in_question = msg.match[1]
    character = new Character(JSON.parse(robot.brain.get("character-#{person_in_question}")))
    if character.dead() == true
      msg.send "#{person_in_question} is dead."
    else
      character.print_show(msg, person_in_question)

  robot.hear /show me the monster/i, (msg) ->
    monster = new Monster(JSON.parse(robot.brain.get("character-monster")))
    monster.print_show(msg)

  robot.hear /attack (\w+)/i, (msg) ->
    person_being_attacked = msg.match[1]
    character = new Character(JSON.parse(robot.brain.get("character-#{msg.message.user.id}")))
    if character.dead() == true
      msg.send "You are dead. You can't attack anybody. Reroll to play again."
    else
      character.attack(msg, robot, person_being_attacked)

  robot.hear /spawn monster/i, (msg) ->
    types = ["Banshee", "Cyclops", "Demon", "Dragon", "Gargoyle", "Goblin", "Kraken", "Mummy", "Zombie", "Sandworm", "Turchioe"]

    monster_type = types[Math.floor(Math.random() * types.length)]

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

    if (monster_type == "Sandworm") or (monster_type == "Dragon")
      hp = 50 + vitality
      strength = 10 if strength < 10
      strength += die.roll(10)
      experience = 25
    else if monster_type == "Turchioe"
      hp = 30 + vitality
      defense = 7 if defense < 7
      defense += defense.roll(6)
      wisdom = die.roll(5)
      intelligence = die.roll(5)
      experience = 15
    else
      hp = 20 + vitality
      experience = 5 + defense

    character_json = {
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
      experience: experience,
      hitpoints: hp,
      hitpoints_remaining: hp,
      monster_type: monster_type
    }

    robot.brain.set("character-monster", JSON.stringify(character_json))
    monster = new Monster(character_json)
    monster.print_spawn(msg)

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
      intelligence += die.roll(5)
    else if character_class == "Hunter"
      hp = 30 + vitality
      dexterity = 7 if dexterity < 7
      dexterity += die.roll(5)
    else if character_class == "Warrior"
      hp = 40 + vitality
      strength = 7 if strength < 7
      strength += die.roll(5)

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
