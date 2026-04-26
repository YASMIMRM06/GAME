import '../../domain/models/character_entity.dart';
import 'package:signals_flutter/signals_flutter.dart';

enum SortBy { name, level, stars }

extension SortByExtension on SortBy {
  int compare(Character a, Character b) {
    switch (this) {
      case SortBy.name:
        return a.name.compareTo(b.name);

      case SortBy.level:
        return a.level.compareTo(b.level);

      case SortBy.stars:
        return a.stars.compareTo(b.stars);
    }
  }
}

enum SortOrder { ascending, descending }

enum LevelFilter { all, below30, below60, upTo70, max80 }

extension LevelFilterExtension on LevelFilter {
  String get label {
    switch (this) {
      case LevelFilter.all:
        return 'Todos';
      case LevelFilter.below30:
        return 'Abaixo de 30';
      case LevelFilter.below60:
        return 'Abaixo de 60';
      case LevelFilter.upTo70:
        return 'Até 70';
      case LevelFilter.max80:
        return 'Level 80';
    }
  }

  bool match(int level) {
    switch (this) {
      case LevelFilter.all:
        return true;

      case LevelFilter.below30:
        return level < 30;

      case LevelFilter.below60:
        return level < 60;

      case LevelFilter.upTo70:
        return level <= 70;

      case LevelFilter.max80:
        return level == 80;
    }
  }
}

class CharactersStateViewmodel {
  /// Estado da Lista de Personagens, inicializada como nula
  final state = Signal<List<Character>>([]);

  /// Mensagem de erro ou aviso, inicializada como nula
  final message = signal<String?>(null);

  /// Indica se o painel de filtros está expandido ou não
  final isFilterPanelExpanded = signal(false);

  /// Ordenação
  final sortBy = signal<SortBy>(SortBy.name);
  final sortOrder = signal<SortOrder>(SortOrder.ascending);

  /// Filtros
  final selectedRarities = signal<Set<CharacterRarity>>({});
  final selectedClasses = signal<Set<CharacterClass>>({});
  final selectedAlignments = signal<Set<CharacterAlignment>>({});
  final levelFilter = signal<LevelFilter>(LevelFilter.all);
  final expandedSections = signal<Set<String>>({});

  /// ------------------------------
  /// FILTROS
  /// ------------------------------
  late final filteredCharacters = computed<List<Character>>(() {
    var filtered = List<Character>.from(state.value);

    /// filtro raridade
    if (selectedRarities.value.isNotEmpty) {
      filtered = filtered
          .where((c) => selectedRarities.value.contains(c.rarity))
          .toList();
    }

    /// filtro classe
    if (selectedClasses.value.isNotEmpty) {
      filtered = filtered
          .where((c) => selectedClasses.value.contains(c.characterClass))
          .toList();
    }

    /// filtro alinhamento
    if (selectedAlignments.value.isNotEmpty) {
      filtered = filtered
          .where((c) => selectedAlignments.value.contains(c.alignment))
          .toList();
    }

    /// filtro level
    // switch (levelFilter.value) {
    //   case LevelFilter.below30:
    //     filtered = filtered.where((c) => c.level < 30).toList();
    //     break;

    //   case LevelFilter.below60:
    //     filtered = filtered.where((c) => c.level < 60).toList();
    //     break;

    //   case LevelFilter.upTo70:
    //     filtered = filtered.where((c) => c.level <= 70).toList();
    //     break;

    //   case LevelFilter.max80:
    //     filtered = filtered.where((c) => c.level == 80).toList();
    //     break;

    //   case LevelFilter.all:
    //     break;
    // }

    filtered = filtered.where((c) => levelFilter.value.match(c.level)).toList();

    return filtered;
  });

  /// ------------------------------
  /// ORDENAÇÃO
  /// ------------------------------
  late final sortedCharacters = computed<List<Character>>(() {
    final list = List<Character>.from(filteredCharacters.value);

    list.sort((a, b) {
      final result = sortBy.value.compare(a, b);

      return sortOrder.value == SortOrder.ascending ? result : -result;
    });

    // switch (sortBy.value) {
    //   case SortBy.name:
    //     list.sort((a, b) {
    //       final compare = a.name.compareTo(b.name);
    //       return sortOrder.value == SortOrder.ascending ? compare : -compare;
    //     });
    //     break;

    //   case SortBy.level:
    //     list.sort((a, b) {
    //       final compare = a.level.compareTo(b.level);
    //       return sortOrder.value == SortOrder.ascending ? compare : -compare;
    //     });
    //     break;

    //   case SortBy.stars:
    //     list.sort((a, b) {
    //       final compare = a.stars.compareTo(b.stars);
    //       return sortOrder.value == SortOrder.ascending ? compare : -compare;
    //     });
    //     break;
    // }

    return list;
  });

  /// ------------------------------
  /// HELPERS PARA UI
  /// ------------------------------

  /// Indica se existem filtros ativos
  // late final hasActiveFilters = computed<bool>(() {
  //   return selectedRarities.value.isNotEmpty ||
  //       selectedClasses.value.isNotEmpty ||
  //       selectedAlignments.value.isNotEmpty ||
  //       levelFilter.value != LevelFilter.all;
  // });

  /// Quantidade de filtros ativos
  late final activeFiltersCount = computed<int>(() {
    int count = 0;

    count += selectedRarities.value.length;
    count += selectedClasses.value.length;
    count += selectedAlignments.value.length;

    if (levelFilter.value != LevelFilter.all) {
      count++;
    }

    return count;
  });

  /// Indica se existem filtros ativos
  late final hasActiveFilters = computed(() => activeFiltersCount.value > 0);

  /// Limpa qualquer mensagem de erro ou aviso
  void clearMessage() => message.value = null;

  /// Define uma mensagem de erro ou aviso
  void setMessage(String msg) => message.value = msg;

  /// ------------------------------
  /// ORDENAÇÃO
  /// ------------------------------

  void setSortBy(SortBy sort) {
    sortBy.value = sort;
  }

  void toggleSortOrder() {
    sortOrder.value = sortOrder.value == SortOrder.ascending
        ? SortOrder.descending
        : SortOrder.ascending;
  }

  /// ------------------------------
  /// FILTROS
  /// ------------------------------

  void toggleRarity(CharacterRarity rarity) {
    final set = Set<CharacterRarity>.from(selectedRarities.value);

    if (set.contains(rarity)) {
      set.remove(rarity);
    } else {
      set.add(rarity);
    }

    selectedRarities.value = set;
  }

  void toggleClass(CharacterClass characterClass) {
    final set = Set<CharacterClass>.from(selectedClasses.value);

    if (set.contains(characterClass)) {
      set.remove(characterClass);
    } else {
      set.add(characterClass);
    }

    selectedClasses.value = set;
  }

  void toggleAlignment(CharacterAlignment alignment) {
    final set = Set<CharacterAlignment>.from(selectedAlignments.value);

    if (set.contains(alignment)) {
      set.remove(alignment);
    } else {
      set.add(alignment);
    }

    selectedAlignments.value = set;
  }

  void toggleFilterPanel() {
    isFilterPanelExpanded.value = !isFilterPanelExpanded.value;
  }

  void setLevelFilter(LevelFilter filter) {
    levelFilter.value = filter;
  }

  bool isSectionExpanded(String key) {
    return expandedSections.value.contains(key);
  }

  void toggleSection(String key) {
    final set = Set<String>.from(expandedSections.value);

    if (set.contains(key)) {
      set.remove(key);
    } else {
      set.add(key);
    }

    expandedSections.value = set;
  }

  void clearFilters() {
    selectedRarities.value = {};
    selectedClasses.value = {};
    selectedAlignments.value = {};
    levelFilter.value = LevelFilter.all;
  }
}
