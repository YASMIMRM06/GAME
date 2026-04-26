import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/app_drawer.dart';

/// Página de informações sobre o jogo
class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sobre o Jogo')),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        padding: AppSpacing.paddingLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Icon(
                Icons.videogame_asset,
                size: 100,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
            // const SizedBox(height: AppSpacing.lg),
            // Text(
            //   'Sobre o Jogo',
            //   style: context.textStyles.headlineMedium?.bold,
            //   textAlign: TextAlign.center,
            // ),
            const SizedBox(height: AppSpacing.xl),
            InfoSection(
              titulo: 'Descrição',
              conteudo:
                  'Um jogo épico de RPG onde você controla heróis poderosos, '
                  'explora mundos fantásticos e enfrenta desafios emocionantes. '
                  'Personalize seus personagens, desenvolva habilidades únicas e '
                  'embarque em uma jornada inesquecível.',
            ),
            const SizedBox(height: AppSpacing.lg),
            InfoSection(
              titulo: 'Recursos',
              conteudo:
                  '• Sistema de combate estratégico\n'
                  '• Mais de 50 personagens únicos\n'
                  '• Mundos vastos para explorar\n'
                  '• Sistema de progressão profundo\n'
                  '• Modo multiplayer cooperativo\n'
                  '• Eventos semanais exclusivos',
            ),
            const SizedBox(height: AppSpacing.lg),
            InfoSection(titulo: 'Versão', conteudo: '1.0.0'),
            const SizedBox(height: AppSpacing.lg),
            InfoSection(
              titulo: 'Desenvolvedores',
              conteudo: 'Team Prof. Roberto',
            ),
            const SizedBox(height: AppSpacing.xl),
            Center(
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Função em desenvolvimento')),
                  );
                },
                icon: Icon(
                  Icons.help_outline,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
                label: Text(
                  'Ajuda e Suporte',
                  style: context.textStyles.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.onPrimary.withValues(alpha: 0.1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoSection extends StatelessWidget {
  final String titulo;
  final String conteudo;

  const InfoSection({super.key, required this.titulo, required this.conteudo});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titulo, style: context.textStyles.titleLarge?.semiBold),
        const SizedBox(height: AppSpacing.sm),
        Container(
          width: double.infinity,
          padding: AppSpacing.paddingMd,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Text(conteudo, style: context.textStyles.bodyMedium),
        ),
      ],
    );
  }
}
