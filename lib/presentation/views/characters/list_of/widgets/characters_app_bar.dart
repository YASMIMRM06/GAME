import 'package:flutter/material.dart';
import 'package:injustice_app/core/theme/app_theme.dart';
import 'package:injustice_app/presentation/controllers/characters_state_viewmodel.dart';
import 'package:signals_flutter/signals_flutter.dart';

class CharactersAppBar extends StatelessWidget implements PreferredSizeWidget {
  final CharactersStateViewmodel state;

  const CharactersAppBar({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Personagens'),
      actions: [
        _SortOrderButton(state: state),
        _SortByButton(state: state),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SortOrderButton extends StatelessWidget {
  final CharactersStateViewmodel state;

  const _SortOrderButton({required this.state});

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      final order = state.sortOrder.value;

      return IconButton(
        icon: Icon(
          order == SortOrder.ascending
              ? Icons.arrow_upward
              : Icons.arrow_downward,
        ),
        onPressed: state.toggleSortOrder,
        tooltip: order == SortOrder.ascending ? 'Ascendente' : 'Descendente',
      );
    });
  }
}

class _SortByButton extends StatelessWidget {
  final CharactersStateViewmodel state;

  const _SortByButton({required this.state});

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      final currentSort = state.sortBy.value;

      return PopupMenuButton<SortBy>(
        icon: const Icon(Icons.sort),
        tooltip: 'Ordenar',
        onSelected: state.setSortBy,
        itemBuilder: (context) => [
          PopupMenuItem(
            value: SortBy.name,
            child: Row(
              children: [
                Icon(
                  Icons.sort_by_alpha,
                  color: currentSort == SortBy.name ? Colors.amber : null,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Nome',
                  style: currentSort == SortBy.name
                      ? const TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                        )
                      : null,
                ),
              ],
            ),
          ),
          PopupMenuItem(
            value: SortBy.level,
            child: Row(
              children: [
                Icon(
                  Icons.trending_up,
                  color: currentSort == SortBy.level ? Colors.amber : null,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Level',
                  style: currentSort == SortBy.level
                      ? const TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                        )
                      : null,
                ),
              ],
            ),
          ),
          PopupMenuItem(
            value: SortBy.stars,
            child: Row(
              children: [
                Icon(
                  Icons.star,
                  color: currentSort == SortBy.stars ? Colors.amber : null,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Estrelas',
                  style: currentSort == SortBy.stars
                      ? const TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                        )
                      : null,
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
