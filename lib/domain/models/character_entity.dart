import 'package:equatable/equatable.dart';

enum CharacterClass {
  poderoso,
  metaHumano,
  agilidade,
  arcano,
  tecnologico;

  String get displayName {
    switch (this) {
      case CharacterClass.poderoso:
        return 'Poderoso';
      case CharacterClass.metaHumano:
        return 'Meta-humano';
      case CharacterClass.agilidade:
        return 'Agilidade';
      case CharacterClass.arcano:
        return 'Arcano';
      case CharacterClass.tecnologico:
        return 'Tecnológico';
    }
  }
}

enum CharacterRarity {
  prata,
  ouro,
  lendario;

  String get displayName {
    switch (this) {
      case CharacterRarity.prata:
        return 'Prata';
      case CharacterRarity.ouro:
        return 'Ouro';
      case CharacterRarity.lendario:
        return 'Lendário';
    }
  }
}

enum CharacterAlignment {
  heroi,
  vilao,
  antiHeroi;

  String get displayName {
    switch (this) {
      case CharacterAlignment.heroi:
        return 'Herói';
      case CharacterAlignment.vilao:
        return 'Vilão';
      case CharacterAlignment.antiHeroi:
        return 'Anti-Herói';
    }
  }
}

class Character extends Equatable {
  final String id;
  final String name;
  final CharacterClass characterClass;
  final CharacterRarity rarity;
  final int level;
  final int threat;
  final int attack;
  final int health;
  final int stars;
  final CharacterAlignment alignment;
  final DateTime createdAt;
  final DateTime updatedAt;

  Character({
    required this.id,
    required this.name,
    required this.characterClass,
    required this.rarity,
    required this.level,
    required this.threat,
    required this.attack,
    required this.health,
    required this.stars,
    required this.alignment,
    required this.createdAt,
    required this.updatedAt,
  }) {
    _validate();
  }

  void _validate() {
    if (level < 1 || level > 80) {
      throw ArgumentError('Level deve estar entre 1 e 80');
    }
    if (threat < 0) {
      throw ArgumentError('Ameaça deve ser maior ou igual a 0');
    }
    if (attack < 0) {
      throw ArgumentError('Ataque deve ser maior ou igual a 0');
    }
    if (health < 0) {
      throw ArgumentError('Vida deve ser maior ou igual a 0');
    }
    if (stars < 1 || stars > 14) {
      throw ArgumentError('Estrelas devem estar entre 1 e 14');
    }
  }

  Character copyWith({
    String? id,
    String? name,
    CharacterClass? characterClass,
    CharacterRarity? rarity,
    int? level,
    int? threat,
    int? attack,
    int? health,
    int? stars,
    CharacterAlignment? alignment,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Character(
      id: id ?? this.id,
      name: name ?? this.name,
      characterClass: characterClass ?? this.characterClass,
      rarity: rarity ?? this.rarity,
      level: level ?? this.level,
      threat: threat ?? this.threat,
      attack: attack ?? this.attack,
      health: health ?? this.health,
      stars: stars ?? this.stars,
      alignment: alignment ?? this.alignment,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        characterClass,
        rarity,
        level,
        threat,
        attack,
        health,
        stars,
        alignment,
        createdAt,
        updatedAt,
      ];

  @override
  String toString() {
    return 'Character('
        'id: $id, '
        'name: $name, '
        'class: ${characterClass.name}, '
        'rarity: ${rarity.name}, '
        'level: $level, '
        'stars: $stars, '
        'threat: $threat, '
        'attack: $attack, '
        'health: $health, '
        'alignment: ${alignment.name}'
        ')';
  }
}
