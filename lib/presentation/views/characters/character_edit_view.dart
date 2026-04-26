import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:signals_flutter/signals_flutter.dart';
import '../../../core/di/dependency_injection.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/models/character_entity.dart';
import '../../controllers/characters_view_model.dart';

class CharacterEditView extends StatefulWidget {
  final Character character;

  const CharacterEditView({super.key, required this.character});

  @override
  State<CharacterEditView> createState() => _CharacterEditViewState();
}

class _CharacterEditViewState extends State<CharacterEditView> {
  late final CharactersViewModel _viewModel;
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _attackController;
  late final TextEditingController _healthController;
  late final TextEditingController _threatController;

  late CharacterClass _selectedClass;
  late CharacterRarity _selectedRarity;
  late CharacterAlignment _selectedAlignment;
  late int _level;
  late int _stars;

  late final void Function() _disposeEffect;

  @override
  void initState() {
    super.initState();
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

    // Mostra erro em SnackBar se o command falhar
    _disposeEffect = effect(() {
      final msg = _viewModel.charactersState.message.value;
      if (msg != null && mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(msg),
              backgroundColor: Colors.red,
            ),
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _disposeEffect();
    _nameController.dispose();
    _attackController.dispose();
    _healthController.dispose();
    _threatController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

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
      updatedAt: DateTime.now(),
    );

    await _viewModel.commands.updateCharacter(characterAtualizado);

    // Volta para a tela anterior após salvar
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Watch((context) {
      final isExecuting =
          _viewModel.commands.updateCharacterCommand.isExecuting.value;

      return Scaffold(
        appBar: AppBar(
          title: const Text('Editar personagem'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          // Botão salvar na AppBar — acesso rápido
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

                // Nome
                TextFormField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration('Nome do personagem', Icons.badge),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Digite o nome' : null,
                ),
                const SizedBox(height: AppSpacing.md),

                // Alinhamento em chips (herói / vilão / anti-herói)
                Text(
                  'Alinhamento',
                  style: context.textStyles.labelLarge?.withColor(
                    colors.onSurfaceVariant,
                  ),
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
                          onSelected: (_) =>
                              setState(() => _selectedAlignment = a),
                          selectedColor: colors.primary,
                          backgroundColor: colors.surfaceContainerHighest,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppSpacing.lg),

                // ── SEÇÃO: Classe e raridade ───────────────────────────
                _SectionHeader(title: 'Classe e Raridade', icon: Icons.shield),
                const SizedBox(height: AppSpacing.sm),

                Row(
                  children: [
                    // Classe
                    Expanded(
                      child: _DropdownField<CharacterClass>(
                        label: 'Classe',
                        value: _selectedClass,
                        items: CharacterClass.values,
                        itemLabel: (c) => c.displayName,
                        onChanged: (v) =>
                            setState(() => _selectedClass = v!),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    // Raridade
                    Expanded(
                      child: _DropdownField<CharacterRarity>(
                        label: 'Raridade',
                        value: _selectedRarity,
                        items: CharacterRarity.values,
                        itemLabel: (r) => r.displayName,
                        onChanged: (v) =>
                            setState(() => _selectedRarity = v!),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),

                // ── SEÇÃO: Nível e estrelas ────────────────────────────
                _SectionHeader(title: 'Progressão', icon: Icons.star),
                const SizedBox(height: AppSpacing.sm),

                // Level
                _SliderField(
                  label: 'Level',
                  value: _level.toDouble(),
                  min: 1,
                  max: 80,
                  divisions: 79,
                  onChanged: (v) => setState(() => _level = v.toInt()),
                ),
                const SizedBox(height: AppSpacing.sm),

                // Estrelas
                _SliderField(
                  label: 'Estrelas',
                  value: _stars.toDouble(),
                  min: 1,
                  max: 14,
                  divisions: 13,
                  onChanged: (v) => setState(() => _stars = v.toInt()),
                ),
                const SizedBox(height: AppSpacing.lg),

                // ── SEÇÃO: Atributos de combate ────────────────────────
                _SectionHeader(title: 'Atributos de Combate', icon: Icons.sports_mma),
                const SizedBox(height: AppSpacing.sm),

                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _attackController,
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.number,
                        decoration: _inputDecoration('Ataque', Icons.flash_on),
                        validator: (v) =>
                            (v == null || int.tryParse(v) == null)
                                ? 'Número inválido'
                                : null,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: TextFormField(
                        controller: _healthController,
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.number,
                        decoration: _inputDecoration('Vida', Icons.favorite),
                        validator: (v) =>
                            (v == null || int.tryParse(v) == null)
                                ? 'Número inválido'
                                : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                TextFormField(
                  controller: _threatController,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration('Ameaça', Icons.warning_amber),
                  validator: (v) =>
                      (v == null || int.tryParse(v) == null)
                          ? 'Número inválido'
                          : null,
                ),
                const SizedBox(height: AppSpacing.xl),

                // ── Botão Atualizar ────────────────────────────────────
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
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.md,
                    ),
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

  // Helper para estilo dos campos de texto
  InputDecoration _inputDecoration(String label, IconData icon) {
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

// ── Widget auxiliar: cabeçalho de seção ───────────────────────────────────────
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
          style: context.textStyles.labelMedium?.withColor(
            colors.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Divider(color: colors.outline.withValues(alpha: 0.4)),
        ),
      ],
    );
  }
}

// ── Widget auxiliar: dropdown estilizado ──────────────────────────────────────
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
          .map((i) => DropdownMenuItem(
                value: i,
                child: Text(itemLabel(i)),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }
}

// ── Widget auxiliar: slider com label ─────────────────────────────────────────
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
            width: 80,
            child: Text(
              '$label: ${value.toInt()}',
              style: context.textStyles.labelLarge?.withColor(
                colors.onSurfaceVariant,
              ),
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