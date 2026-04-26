class AppMessages {
  static const error = _Error();
}

class _Error {
  const _Error();
  final String defaultError = 'Ocorreu um erro inesperado.';
  final String inputError = 'Entrada inválida.';
  final String apiLocalError = 'Erro de armazenamento de local.';

  final String emptyResultError = 'Nenhum resultado encontrado.';

  final String nullStringError = 'Valor nulo ou vazio não é permitido.';
  final String invalidDateError = 'Data inválida. Use o formato DD/MM/AAAA.';
  final String invalidEmailError = 'Email inválido.';
  final String maxDoubleError = 'Valor excede o máximo permitido.';
  final String minDoubleError = 'Valor é menor que o mínimo permitido.';
  final String longerStringError =
      'Valor excede o número máximo de caracteres.';
  final String shorterStringError =
      'Valor é menor que o número mínimo de caracteres.';
  final String lowerCharMissedError =
      'A senha deve conter pelo menos uma letra minúscula.';
  final String upperCharMissedError =
      'A senha deve conter pelo menos uma letra maiúscula.';
  final String specialCharMissedError =
      'A senha deve conter pelo menos um caractere especial.';
  final String digitMissedError = 'A senha deve conter pelo menos um dígito.';
  final String invalidPasswordError = 'Campo não pode ser vazio.';
  final String passwordMismatchError = 'As senhas não coincidem.';
  final String invalidPhoneError = 'Número de telefone inválido.';
}
