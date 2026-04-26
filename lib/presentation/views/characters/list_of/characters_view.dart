import 'package:flutter/material.dart';
import 'package:injustice_app/presentation/widgets/app_drawer.dart';
import 'widgets/characters_app_bar.dart';
import 'widgets/characters_body.dart';
import 'widgets/characters_floating_button.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/models/account_entity.dart';
import '../../../controllers/characters_view_model.dart';

/// Página de listagem de personagens
class CharactersView extends StatefulWidget {
  final Account account;

  const CharactersView({super.key, required this.account});

  @override
  State<CharactersView> createState() => _CharactersViewState();
}

class _CharactersViewState extends State<CharactersView> {
  late final CharactersViewModel _viewModel;
  Account get account => widget.account;

  @override
  void initState() {
    super.initState();
    _viewModel = injector.get<CharactersViewModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.commands.fetchCharacters();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CharactersAppBar(state: _viewModel.charactersState),
      drawer: AppDrawer(),
      body: CharactersBody(account: account, viewModel: _viewModel),
      floatingActionButton: CharactersFab(viewModel: _viewModel),
    );
  }
}