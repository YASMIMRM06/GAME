// character_class_ui.dart
import 'package:flutter/material.dart';
import 'package:injustice_app/domain/models/character_entity.dart';

extension ClassUI on CharacterClass {
  Color get color {
    switch (this) {
      case CharacterClass.poderoso:
        return Colors.deepOrangeAccent;
      case CharacterClass.metaHumano:
        return Colors.yellowAccent;
      case CharacterClass.agilidade:
        return Colors.greenAccent;
      case CharacterClass.arcano:
        return Colors.purpleAccent;
      case CharacterClass.tecnologico:
        return Colors.blueAccent;
    }
  }

  IconData get icon {
    switch (this) {
      case CharacterClass.poderoso:
        return Icons.fitness_center;
      case CharacterClass.metaHumano:
        return Icons.flash_on;
      case CharacterClass.agilidade:
        return Icons.speed;
      case CharacterClass.arcano:
        return Icons.auto_fix_high;
      case CharacterClass.tecnologico:
        return Icons.settings;
    }
  }
}

extension RarityUI on CharacterRarity {
  Color get color {
    switch (this) {
      case CharacterRarity.lendario:
        return Colors.purple;
      case CharacterRarity.ouro:
        return Colors.amber;
      case CharacterRarity.prata:
        return Colors.grey;
    }
  }
}
