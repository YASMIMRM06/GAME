import 'package:flutter/material.dart';
import '../failure/failure.dart';
import '../../domain/models/account_entity.dart';
import '../../domain/models/character_entity.dart';

import '../patterns/result.dart';

// typedefs para tipo Result
typedef VoidResult = Result<void, Failure>;
typedef AccountResult = Result<Account, Failure>;
typedef CharacterResult = Result<Character,Failure>;
typedef ListCharacterResult = Result<List<Character>, Failure>;

// typedfs para parâmetros
typedef AccountParams = ({Account account});

/// tipos usadoos Conta de Usuario
typedef NoParams = ();
typedef AccountNameParams = ({String accountName});
/// tipos usados para Personagem
typedef CharacterIdParams = ({String id});
typedef CharacterParams = ({Character character});

/// typedefs para ser usados em componentes de UI
typedef FormFieldControl = ({
  GlobalKey<FormFieldState> key,
  FocusNode focus,
  TextEditingController controller,
});
