import 'package:go_router/go_router.dart';

import '../../domain/models/account_entity.dart';
import '../../domain/models/character_entity.dart'; 
import '../../presentation/views/about_view.dart';
import '../../presentation/views/account_create_view.dart';
import '../../presentation/views/characters/character_edit_view.dart'; 
import '../../presentation/views/characters/list_of/characters_view.dart';
import '../../presentation/views/home_view.dart';

/// Route names for easier referencing
class AppRouteNames {
  static const home = 'home';
  static const about = 'about';
  static const accountCreate = 'account_create';
  static const characters = 'characters';
  static const characterEdit = 'character_edit'; 
}

/// Paths to keep URL structure consistent
class AppPaths {
  static const home = '/home';
  static const about = '/about';
  static const accountCreate = '/account-create';
  static const characters = '/characters';
  static const characterEdit = '/character-edit'; 
}

/// app routers using go_router
class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppPaths.home,
    routes: <RouteBase>[
      GoRoute(
        path: AppPaths.home,
        name: AppRouteNames.home,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: HomeView()),
      ),
      GoRoute(
        path: AppPaths.accountCreate,
        name: AppRouteNames.accountCreate,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: AccountCreateView()),
      ),
      GoRoute(
        path: AppPaths.characters,
        name: AppRouteNames.characters,
        pageBuilder: (context, state) {
          final account = state.extra as Account;
          return NoTransitionPage(child: CharactersView(account: account));
        },
      ),
      GoRoute(
        path: AppPaths.about,
        name: AppRouteNames.about,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: AboutView()),
      ),
      //  tela de edição de personagem
      GoRoute(
        path: AppPaths.characterEdit,
        name: AppRouteNames.characterEdit,
        pageBuilder: (context, state) {
          // pega o personagem que veio da tela anterior
          final character = state.extra as Character;
          return NoTransitionPage(
            child: CharacterEditView(character: character),
          );
        },
      ),
    ],
  );
}