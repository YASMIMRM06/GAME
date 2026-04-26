import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/di/dependency_injection.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_theme.dart';
import '../controllers/account_viewmodel.dart';
import '../widgets/app_drawer.dart';
import 'package:intl/intl.dart';
import 'package:signals_flutter/signals_flutter.dart';


class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final AccountViewModel _vmAccount;
  @override
  void initState() {
    _vmAccount = injector.get<AccountViewModel>();
    _vmAccount.getAccountCommand();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inj2 Mobile - Player Acc')),
      drawer: AppDrawer(),
      body: Watch((context) {
       
        if (_vmAccount.saveAccountCommand.isExecuting.value) {
          return const Center(child: CircularProgressIndicator());
        }
       
        if (!_vmAccount.accountState.hasAccount.value) {
          return _buildAboutContent(context);
        }

        return _accountHeaderCard(context);
      }),
    );
  }

  /// Constrói o conteúdo "Sobre o jogo" quando não há conta
  Widget _buildAboutContent(BuildContext context) {
    return SingleChildScrollView(
      padding: AppSpacing.paddingLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Icon(
              Icons.videogame_asset,
              size: 100,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Bem-vindo ao Game App',
            style: context.textStyles.headlineMedium?.bold.withColor(
              Theme.of(context).colorScheme.onSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          _InfoSection(
            titulo: 'Descrição',
            conteudo:
                'Um jogo épico de RPG onde você controla heróis poderosos, '
                'explora mundos fantásticos e enfrenta desafios emocionantes. '
                'Personalize seus personagens, desenvolva habilidades únicas e '
                'embarque em uma jornada inesquecível.',
          ),
          const SizedBox(height: AppSpacing.lg),
          _InfoSection(
            titulo: 'Recursos',
            conteudo:
                '• Sistema de combate estratégico\n'
                '• Mais de 50 personagens únicos\n'
                '• Mundos vastos para explorar\n'
                '• Sistema de progressão profundo\n'
                '• Modo multiplayer cooperativo\n'
                '• Eventos semanais exclusivos',
          ),
          const SizedBox(height: AppSpacing.xl),
          Center(
            child: FilledButton.icon(
              // onPressed: () => context.push(AppRoutes.criarConta),
              onPressed: () => context.goNamed(AppRouteNames.accountCreate),
              icon: const Icon(Icons.person_add),
              label: const Text('Criar Conta para Começar'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.md,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Constrói o conteúdo com dados da conta
  Widget _accountHeaderCard(BuildContext context) {
    final account = _vmAccount.accountState.state.value!;
    // final account = AccountFactory.single();
    // final account = _viewModel.currentAccount.value!;

    return RefreshIndicator(
      onRefresh: () async => await _vmAccount.getAccountCommand(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: AppSpacing.paddingLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho com informações básicas
            _AccountHeaderCard(
              displayName: account.displayName,
              email: account.email,
              level: account.level,
            ),
            const SizedBox(height: AppSpacing.lg),

            // Recursos da conta (Gold, Gemas, Energia)
            Text('Recursos', style: context.textStyles.titleLarge?.semiBold),
            const SizedBox(height: AppSpacing.md),

            // Linha superior: Gemas + Energia
            Row(
              children: [
                Expanded(
                  child: _ResourceCard(
                    icon: Icons.diamond,
                    label: 'Gemas',
                    value: account.gems.toString(),
                    color: Colors.cyan,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _ResourceCard(
                    icon: Icons.bolt,
                    label: 'Energia',
                    value: account.energy.toString(),
                    color: Colors.green,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.md),

            // Linha inferior: Gold centralizado
            Center(
              child: FractionallySizedBox(
                widthFactor: 0.6, // controla o "peso visual" do card
                child: _ResourceCard(
                  icon: Icons.monetization_on,
                  label: 'Gold',
                  value: NumberFormat.currency(
                    locale: 'en_US',
                    symbol: '\$ ',
                    decimalDigits: 2,
                  ).format(account.gold),
                  color: Colors.amber,
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Informações adicionais
            Text(
              'Informações da Conta',
              style: context.textStyles.titleLarge?.semiBold,
            ),
            const SizedBox(height: AppSpacing.md),
            _InfoCard(
              icon: Icons.calendar_today,
              label: 'Data de Criação',
              value: DateFormat('dd/MM/yyyy').format(account.createdAt),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Botão para ver personagens
            Center(
              child: FilledButton.icon(
                onPressed: () => context.goNamed(AppRouteNames.characters),
                // onPressed: () => context.push(AppRoutes.personagens),
                icon: const Icon(Icons.people),
                label: const Text('Ver Meus Personagens'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                    vertical: AppSpacing.md,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Card de cabeçalho com informações básicas da conta
class _AccountHeaderCard extends StatelessWidget {
  final String displayName;
  final String email;
  final int level;

  const _AccountHeaderCard({
    required this.displayName,
    required this.email,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppSpacing.paddingLg,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.secondary.withValues(alpha: 0.8),
            Theme.of(context).colorScheme.tertiary,
            Theme.of(context).colorScheme.secondary,
            Theme.of(context).colorScheme.secondary.withValues(alpha: 0.9),
            Theme.of(context).colorScheme.secondary,
            Theme.of(context).colorScheme.tertiary,
            Theme.of(context).colorScheme.secondary.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Theme.of(context).colorScheme.onSecondary,
                child: Text(
                  displayName[0].toUpperCase(),
                  style: context.textStyles.headlineMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: context.textStyles.headlineSmall?.copyWith(
                        // color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      email,
                      style: context.textStyles.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.military_tech,
                  color: Theme.of(context).colorScheme.onSecondary,
                  size: 20,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Level $level',
                  style: context.textStyles.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSecondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Card para exibir recursos (Gold, Gemas, Energia)
class _ResourceCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _ResourceCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.paddingMd,
      decoration: BoxDecoration(
        // color: Theme.of(context).colorScheme.surfaceContainerHighest,
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(AppRadius.md),
        // border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: AppSpacing.sm),
          Text(
            label,
            style: context.textStyles.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: context.textStyles.titleLarge?.bold.withColor(color),
          ),
        ],
      ),
    );
  }
}

/// Card para informações adicionais
class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.paddingMd,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary, size: 24),
          const SizedBox(width: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: context.textStyles.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(value, style: context.textStyles.titleMedium?.semiBold),
            ],
          ),
        ],
      ),
    );
  }
}

/// Seção de informação reutilizável
class _InfoSection extends StatelessWidget {
  final String titulo;
  final String conteudo;

  const _InfoSection({required this.titulo, required this.conteudo});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: context.textStyles.titleLarge?.semiBold.withColor(
            Theme.of(context).colorScheme.onSecondary,
          ),
        ),
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
          child: Text(
            conteudo,
            style: context.textStyles.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
