import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:signals_flutter/signals_flutter.dart';
import '../../../core/di/dependency_injection.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/models/character_entity.dart';
import '../../controllers/characters_view_model.dart';

/// Tela de edição de personagem
/// Recebe o [character] da tela anterior via route extra (app_routes.dart)
/// Preenche os campos com os dados do personagem e permite atualizar
class CharacterEditView extends StatefulWidget {
  // Personagem recebido da tela anterior via route extra
  final Character character;

  const CharacterEditView({super.key, required this.character});

  @override
  State<CharacterEditView> createState() => _CharacterEditViewState();
}

class _CharacterEditViewState extends State<CharacterEditView> {
  // ViewModel singleton — mesmo que a tela de lista usa
  late final CharactersViewModel _viewModel;

  // Chave para validar o formulário
  final _formKey = GlobalKey<FormState>();

  // Controllers dos campos de texto — preenchidos com dados do personagem
  late final TextEditingController _nameController;
  late final TextEditingController _attackController;
  late final TextEditingController _healthController;
  late final TextEditingController _threatController;

  // Estado local dos campos de enum e numéricos
  late CharacterClass _selectedClass;
  late CharacterRarity _selectedRarity;
  late CharacterAlignment _selectedAlignment;
  late int _level;
  late int _stars;

  @override
  void initState() {
    super.initState();
    // Pega o ViewModel do injetor de dependência (mesmo que o professor usa)
    _viewModel = injector.get<CharactersViewModel>();

    // Preenche todos os campos com os dados do personagem recebido
    _nameController = TextEditingController(text: widget.character.name);
    _attackController = TextEditingController(text: widget.character.attack.toString());
    _healthController = TextEditingController(text: widget.character.health.toString());
    _threatController = TextEditingController(text: widget.character.threat.toString());
    _selectedClass = widget.character.characterClass;
    _selectedRarity = widget.character.rarity;
    _selectedAlignment = widget.character.alignment;
    _level = widget.character.level;
    _stars = widget.character.stars;
  }

  @override
  void dispose() {
    // Libera os controllers ao sair da tela
    _nameController.dispose();
    _attackController.dispose();
    _healthController.dispose();
    _threatController.dispose();
    super.dispose();
  }

  /// Chamado ao apertar Salvar ou o botão na AppBar
  /// Valida o formulário, chama o UpdateCharacterCommand e volta para a lista
  Future<void> _salvar() async {
    // Valida os campos — se inválido, não prossegue
    if (!_formKey.currentState!.validate()) return;

    // Cria um Character novo com os dados alterados
    // copyWith mantém os campos originais e só substitui os que você passar
    final characterAtualizado = widget.character.copyWith(
      name: _nameController.text.trim(),
      characterClass: _selectedClass,
      rarity: _selectedRarity,
      alignment: _selectedAlignment,
      level: _level,
      stars: _stars,
      attack: int.tryParse(_attackController.text) ?? widget.character.attack,
      health: int.tryParse(_healthController.text) ?? widget.character.health,
      threat: int.tryParse(_threatController.text) ?? widget.character.threat,
      updatedAt: DateTime.now(), // atualiza a data de modificação
    );

    // Aguarda o command terminar completamente antes de checar o resultado
    await _viewModel.commands.updateCharacter(characterAtualizado);

    // Se não estiver mais na tela, não faz nada
    if (!mounted) return;

    // Checa a mensagem de erro do estado
    // null = sucesso → volta para a lista
    // com mensagem = erro → mostra SnackBar e fica na tela
    final msg = _viewModel.charactersState.message.value;
    if (msg != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: Colors.red),
      );
    } else {
      context.pop(); // volta para a tela anterior (lista de personagens)
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    // Watch reconstrói a tela quando isExecuting muda
    // (para desabilitar o botão enquanto salva)
    return Watch((context) {
      final isExecuting =
          _viewModel.commands.updateCharacterCommand.isExecuting.value;

      return Scaffold(
        appBar: AppBar(
          title: const Text('Editar personagem'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(), // botão de voltar sem salvar
          ),
          // Botão salvar na AppBar — atalho para o mesmo _salvar()
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: TextButton.icon(
                onPressed: isExecuting ? null : _salvar,
                icon: isExecuting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.check, color: Colors.white),
                label: Text(
                  isExecuting ? 'Salvando...' : 'Salvar',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),

        body: SingleChildScrollView(
          padding: AppSpacing.paddingMd,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                // ── SEÇÃO: Identidade ──────────────────────────────────
                _SectionHeader(title: 'Identidade', icon: Icons.person),
                const SizedBox(height: AppSpacing.sm),

                // Campo: Nome
                TextFormField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration(context, 'Nome do personagem', Icons.badge),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Digite o nome' : null,
                ),
                const SizedBox(height: AppSpacing.md),

                // Campo: Alinhamento — chips lado a lado
                Text(
                  'Alinhamento',
                  style: context.textStyles.labelLarge?.withColor(colors.onSurfaceVariant),
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: CharacterAlignment.values.map((a) {
                    final selected = _selectedAlignment == a;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: AppSpacing.xs),
                        child: ChoiceChip(
                          label: Text(
                            a.displayName,
                            style: TextStyle(
                              color: selected ? Colors.white : colors.onSurfaceVariant,
                              fontSize: 12,
                            ),
                          ),
                          selected: selected,
                          onSelected: (_) => setState(() => _selectedAlignment = a),
                          selectedColor: colors.primary,
                          backgroundColor: colors.surfaceContainerHighest,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppSpacing.lg),

                // ── SEÇÃO: Classe e Raridade ───────────────────────────
                _SectionHeader(title: 'Classe e Raridade', icon: Icons.shield),
                const SizedBox(height: AppSpacing.sm),

                // Classe e Raridade lado a lado
                Row(
                  children: [
                    Expanded(
                      child: _DropdownField<CharacterClass>(
                        label: 'Classe',
                        value: _selectedClass,
                        items: CharacterClass.values,
                        itemLabel: (c) => c.displayName,
                        onChanged: (v) => setState(() => _selectedClass = v!),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _DropdownField<CharacterRarity>(
                        label: 'Raridade',
                        value: _selectedRarity,
                        items: CharacterRarity.values,
                        itemLabel: (r) => r.displayName,
                        onChanged: (v) => setState(() => _selectedRarity = v!),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),

                // ── SEÇÃO: Progressão ──────────────────────────────────
                _SectionHeader(title: 'Progressão', icon: Icons.star),
                const SizedBox(height: AppSpacing.sm),

                // Level: slider de 1 a 80
                _SliderField(
                  label: 'Level',
                  value: _level.toDouble(),
                  min: 1,
                  max: 80,
                  divisions: 79,
                  onChanged: (v) => setState(() => _level = v.toInt()),
                ),
                const SizedBox(height: AppSpacing.sm),

                // Estrelas: slider de 1 a 14
                _SliderField(
                  label: 'Estrelas',
                  value: _stars.toDouble(),
                  min: 1,
                  max: 14,
                  divisions: 13,
                  onChanged: (v) => setState(() => _stars = v.toInt()),
                ),
                const SizedBox(height: AppSpacing.lg),

                // ── SEÇÃO: Atributos de Combate ────────────────────────
                _SectionHeader(title: 'Atributos de Combate', icon: Icons.sports_mma),
                const SizedBox(height: AppSpacing.sm),

                // Ataque e Vida lado a lado
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _attackController,
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.number,
                        decoration: _inputDecoration(context, 'Ataque', Icons.flash_on),
                        validator: (v) =>
                            (v == null || int.tryParse(v) == null) ? 'Número inválido' : null,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: TextFormField(
                        controller: _healthController,
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.number,
                        decoration: _inputDecoration(context, 'Vida', Icons.favorite),
                        validator: (v) =>
                            (v == null || int.tryParse(v) == null) ? 'Número inválido' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                // Ameaça
                TextFormField(
                  controller: _threatController,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration(context, 'Ameaça', Icons.warning_amber),
                  validator: (v) =>
                      (v == null || int.tryParse(v) == null) ? 'Número inválido' : null,
                ),
                const SizedBox(height: AppSpacing.xl),

                // ── Botão Atualizar ────────────────────────────────────
                // isExecuting desabilita o botão enquanto o command roda
                ElevatedButton.icon(
                  onPressed: isExecuting ? null : _salvar,
                  icon: isExecuting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.save),
                  label: Text(
                    isExecuting ? 'Salvando...' : 'Atualizar personagem',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ),
      );
    });
  }

  /// Helper para estilo padrão dos campos de texto
  InputDecoration _inputDecoration(BuildContext context, String label, IconData icon) {
    final colors = Theme.of(context).colorScheme;
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: colors.onSurfaceVariant),
      prefixIcon: Icon(icon, color: colors.onSurfaceVariant, size: 20),
      filled: true,
      fillColor: colors.surfaceContainerHighest,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: BorderSide(color: colors.primary, width: 2),
      ),
    );
  }
}

// =============================================================================
//   WIDGETS AUXILIARES — usados apenas nessa tela
// =============================================================================

/// Cabeçalho de seção com ícone e linha divisória
class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 18, color: colors.onSurfaceVariant),
        const SizedBox(width: AppSpacing.xs),
        Text(
          title.toUpperCase(),
          style: context.textStyles.labelMedium?.withColor(colors.onSurfaceVariant),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Divider(color: colors.outline.withValues(alpha: 0.4)),
        ),
      ],
    );
  }
}

/// Dropdown estilizado com o tema do app
class _DropdownField<T> extends StatelessWidget {
  final String label;
  final T value;
  final List<T> items;
  final String Function(T) itemLabel;
  final void Function(T?) onChanged;

  const _DropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return DropdownButtonFormField<T>(
      value: value,
      dropdownColor: colors.surfaceContainerHighest,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: colors.onSurfaceVariant),
        filled: true,
        fillColor: colors.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
      ),
      items: items
          .map((i) => DropdownMenuItem(value: i, child: Text(itemLabel(i))))
          .toList(),
      onChanged: onChanged,
    );
  }
}

/// Slider com label e fundo preenchido com o tema do app
class _SliderField extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final void Function(double) onChanged;

  const _SliderField({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              '$label: ${value.toInt()}',
              style: context.textStyles.labelLarge?.withColor(colors.onSurfaceVariant),
            ),
          ),
          Expanded(
            child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              label: value.toInt().toString(),
              activeColor: colors.primary,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}