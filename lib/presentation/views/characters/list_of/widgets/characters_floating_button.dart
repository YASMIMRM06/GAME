import 'package:flutter/material.dart';
import 'package:injustice_app/helper_dev/fakes/character_factory.dart';
import 'package:injustice_app/presentation/controllers/characters_view_model.dart';
import 'package:signals_flutter/signals_flutter.dart';

class CharactersFab extends StatelessWidget {
  final CharactersViewModel viewModel;

  const CharactersFab({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      final isExecuting =
          viewModel.commands.createCharacterCommand.isExecuting.value;

      return FloatingActionButton(
        onPressed: isExecuting
            ? null
            : () async {
                final character = CharacterFactory.list(1).first;
                await viewModel.commands.addCharacter(character);
              },
        child: isExecuting
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.add),
      );
    });
  }
}
