import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../domain/models/account_entity.dart';
import '../../../../../domain/models/character_entity.dart';
import '../../../../../domain/models/extensions/character_ui.dart';
import '../../../../controllers/characters_state_viewmodel.dart';
import '../../../../controllers/characters_view_model.dart';
import '../../../../widgets/account_summary_card.dart';
import '../../../../widgets/loading_indicator.dart';
import '../../../../widgets/star_rating.dart';
import 'empty_state.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/routes/app_routes.dart';

class CharactersBody extends StatelessWidget {
  final CharactersViewModel viewModel;
  final Account account;

  const CharactersBody({
    super.key,
    required this.viewModel,
    required this.account,
  });

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      final isLoading =
          viewModel.commands.getAllCharactersCommand.isExecuting.value;

      final characters = viewModel.charactersState.sortedCharacters.value;

      return RefreshIndicator(
        onRefresh: () async {},
        child: CustomScrollView(
          slivers: [
            /// Header
            SliverToBoxAdapter(
              child: Padding(
                padding: AppSpacing.paddingMd,
                child: AccountSummaryCard(account: account),
              ),
            ),

            /// Filtros
            SliverToBoxAdapter(child: FilterPanel(viewModel: viewModel)),

            /// Conteúdo (loading | empty | lista)
            if (isLoading)
              SliverFillRemaining(
                hasScrollBody: false,
                child: LoadingIndicator(message: 'Carregando personagens...'),
              )
            else if (characters.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: EmptyState.noCharacters(),
              )
            else
              SliverPadding(
                padding: AppSpacing.paddingMd,
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final character = characters[index];
                    return CharacterListItem(
                      character: character,
                      onDelete: () => viewModel.commands.deleteCharacter(character.id),
                      onTap: () => context.pushNamed(
                        AppRouteNames.characterEdit,
                        extra: character,
                      ),
                    );
                  }, childCount: characters.length),
                ),
              ),
          ],
        ),
      );
    });
  }
}

/// Item da lista de personagens
class CharacterListItem extends StatelessWidget {
  final Character character;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const CharacterListItem({
    super.key,
    required this.character,
    required this.onDelete,
    required this.onTap,
  });

  // Mostra o diálogo de confirmação antes de deletar
  Future<void> _confirmarExclusao(BuildContext context) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: Text('Deseja realmente excluir ${character.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Excluir',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    // Só chama onDelete se o usuário confirmou
    if (confirmado == true) {
      onDelete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.9),
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Padding(
        padding: AppSpacing.paddingMd,
        child: Row(
          children: [
            // Indicador de raridade
            Container(
              width: 4,
              height: 60,
              decoration: BoxDecoration(
                color: character.rarity.color,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
            ),
            const SizedBox(width: AppSpacing.md),

            // Conteúdo principal
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          character.name,
                          style: context.textStyles.titleMedium?.semiBold,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        'Nv. ${character.level}',
                        style: context.textStyles.labelLarge?.withColor(
                          Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      Icon(
                        character.characterClass.icon,
                        size: 16,
                        color: character.characterClass.color,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        character.characterClass.displayName,
                        style: context.textStyles.bodySmall?.withColor(
                          Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  StarRating(stars: character.stars, size: 14),
                ],
              ),
            ),

            // ✅ BOTÃO EDITAR — toque simples, navega para a tela de edição
            IconButton(
              onPressed: onTap,
              icon: const Icon(Icons.edit),
              color: Colors.blue,
              tooltip: 'Editar',
            ),

            // ✅ BOTÃO EXCLUIR — toque simples, abre diálogo de confirmação
            IconButton(
              onPressed: () => _confirmarExclusao(context),
              icon: const Icon(Icons.delete),
              color: Colors.red,
              tooltip: 'Excluir',
            ),
          ],
        ),
      ),
    );
  }
}

class FilterPanel extends StatelessWidget {
  final CharactersViewModel viewModel;

  const FilterPanel({super.key, required this.viewModel});

  CharactersStateViewmodel get state => viewModel.charactersState;

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      final filtersCount = state.activeFiltersCount.value;
      final isExpanded = state.isFilterPanelExpanded.value;

      return Container(
        margin: EdgeInsets.only(
          left: AppSpacing.md,
          right: AppSpacing.md,
          bottom: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.secondary.withValues(alpha: 0.85),
              Theme.of(context).colorScheme.secondary,
              Theme.of(context).colorScheme.secondary.withValues(alpha: 0.85),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppRadius.md),
          color: Theme.of(context).colorScheme.secondary,
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).colorScheme.outlineVariant,
              width: 1,
            ),
          ),
        ),
        child: Column(
          children: [
            // Cabeçalho do painel
            InkWell(
              onTap: state.toggleFilterPanel,
              child: Padding(
                padding: AppSpacing.paddingMd,
                child: Row(
                  children: [
                    Icon(
                      Icons.filter_list,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'Filtros',
                      style: context.textStyles.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    if (filtersCount > 0) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$filtersCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],

                    const Spacer(),

                    if (filtersCount > 0)
                      TextButton.icon(
                        onPressed: state.clearFilters,
                        icon: const Icon(Icons.clear, size: 16),
                        label: const Text('Limpar'),
                        style: TextButton.styleFrom(
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.onSecondary,
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                          ),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ],
                ),
              ),
            ),

            // Conteúdo do painel (expansível)
            if (isExpanded)
              SizedBox(
                width: double.infinity,
                child: _FiltersContent(state: state),
              ),
          ],
        ),
      );
    });
  }
}

class _FiltersContent extends StatelessWidget {
  const _FiltersContent({required this.state});

  final CharactersStateViewmodel state;

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.md,
          AppSpacing.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _FilterSection(
              title: 'Raridade',
              sectionKey: 'rarity',
              state: state,
              child: Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: CharacterRarity.values.map((rarity) {
                  final isSelected = state.selectedRarities.value.contains(rarity);
                  return FilterChip(
                    label: Text(rarity.displayName, style: TextStyle(color: rarity.color)),
                    selected: isSelected,
                    onSelected: (_) => state.toggleRarity(rarity),
                  );
                }).toList(),
              ),
            ),
            _FilterSection(
              title: 'Classe',
              sectionKey: 'class',
              state: state,
              child: Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: CharacterClass.values.map((characterClass) {
                  final isSelected = state.selectedClasses.value.contains(characterClass);
                  return FilterChip(
                    label: Text(characterClass.displayName, style: TextStyle(color: characterClass.color)),
                    selected: isSelected,
                    onSelected: (_) => state.toggleClass(characterClass),
                  );
                }).toList(),
              ),
            ),
            _FilterSection(
              title: 'Level',
              sectionKey: 'level',
              state: state,
              child: Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: LevelFilter.values.map((filter) {
                  return FilterChip(
                    label: Text(filter.label),
                    selected: state.levelFilter.value == filter,
                    onSelected: (_) => state.setLevelFilter(filter),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _FilterSection extends StatelessWidget {
  final String title;
  final String sectionKey;
  final CharactersStateViewmodel state;
  final Widget child;

  const _FilterSection({
    required this.title,
    required this.sectionKey,
    required this.state,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      final isExpanded = state.isSectionExpanded(sectionKey);
      final selectedCount = switch (sectionKey) {
        'rarity' => state.selectedRarities.value.length,
        'class' => state.selectedClasses.value.length,
        'alignment' => state.selectedAlignments.value.length,
        _ => 0,
      };

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => state.toggleSection(sectionKey),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
              child: Row(
                children: [
                  Text(title),
                  if (selectedCount > 0) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '$selectedCount',
                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                  const Spacer(),
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: child,
            ),
            crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      );
    });
  }
}