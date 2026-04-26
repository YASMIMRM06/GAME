import 'character_entity.dart';

class CharacterMapper {
  static Map<String, dynamic> toMap(Character character) {
    return {
      'id': character.id,
      'name': character.name,
      'characterClass': character.characterClass.name,
      'rarity': character.rarity.name,
      'level': character.level,
      'threat': character.threat,
      'attack': character.attack,
      'health': character.health,
      'stars': character.stars,
      'alignment': character.alignment.name,
      'createdAt': character.createdAt.toIso8601String(),
      'updatedAt': character.updatedAt.toIso8601String(),
    };
  }

  static Character fromMap(Map<String, dynamic> map) {
    return Character(
      id: map['id'] as String,
      name: map['name'] as String,
      characterClass:
          CharacterClass.values.byName(map['characterClass'] as String),
      rarity:
          CharacterRarity.values.byName(map['rarity'] as String),
      level: map['level'] as int,
      threat: map['threat'] as int,
      attack: map['attack'] as int,
      health: map['health'] as int,
      stars: map['stars'] as int,
      alignment:
          CharacterAlignment.values.byName(map['alignment'] as String),
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }
}
