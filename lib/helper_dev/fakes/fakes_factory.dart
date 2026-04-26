import 'package:faker_dart/faker_dart.dart';
import '../../domain/models/account_entity.dart';
import '../../domain/models/character_entity.dart';

abstract class FakeFactory {
  static final Faker _faker = Faker.instance..setLocale(FakerLocaleType.pt_PT);

  // ======================
  // Account
  // ======================
  static Account account() {
    final now = DateTime.now();

    return Account(
      name: _faker.name.fullName(),
      email: _faker.internet.email(),
      displayName: _faker.name.firstName(),
      createdAt: now.subtract(
        Duration(days: _faker.datatype.number(min: 10, max: 365)),
      ),
      updatedAt: now,
      level: _faker.datatype.number(min: 1, max: 80),
      gold: _faker.datatype.float(min: 0, max: 100000, precision: 2),
      gems: _faker.datatype.number(min: 0, max: 500),
      energy: _faker.datatype.number(min: 1, max: 100),
    );
  }

  // ======================
  // Character
  // ======================
  static Character character() {
    final now = DateTime.now();

    return Character(
      id: _faker.datatype.uuid(),
      name: _faker.name.firstName(),
      characterClass: CharacterClass
          .values[_faker.datatype.number(max: CharacterClass.values.length)],
      rarity: CharacterRarity
          .values[_faker.datatype.number(max: CharacterRarity.values.length)],
      alignment: CharacterAlignment.values[
          _faker.datatype.number(max: CharacterAlignment.values.length)],
      level: _faker.datatype.number(min: 1, max: 80),
      stars: _faker.datatype.number(min: 1, max: 14),
      threat: _faker.datatype.number(min: 0, max: 500),
      attack: _faker.datatype.number(min: 50, max: 1000),
      health: _faker.datatype.number(min: 100, max: 5000),
      createdAt: now.subtract(
        Duration(days: _faker.datatype.number(min: 1, max: 180)),
      ),
      updatedAt: now,
    );
  }
}
