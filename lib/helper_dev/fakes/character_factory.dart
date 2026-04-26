import '../../domain/models/character_entity.dart';
import 'fakes_factory.dart';

class CharacterFactory {
  /// Cria uma instância de Character com dados falsos
  static Character single() {
    return FakeFactory.character();
  }

  /// Cria uma lista de Accounts com dados falsos
  static List<Character> list([int count = 5]) {
    var list = List.generate(
      count,
      (index) => single(),
    );

    return list;
  }
}