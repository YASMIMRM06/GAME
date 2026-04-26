import '../messages/app_messages.dart';

sealed class Failure implements Exception {
  final String msg;
  Failure(this.msg);

  @override
  String toString() => '$runtimeType: $msg!!!';
}

class DefaultFailure extends Failure {
  DefaultFailure([String? msg]) : super(msg ?? AppMessages.error.defaultError);
}

class ApiLocalFailure extends Failure {
  ApiLocalFailure([String? msg])
    : super(msg ?? AppMessages.error.apiLocalError);
}

class EmptyResultFailure extends Failure {
  EmptyResultFailure([String? msg])
    : super(msg ?? AppMessages.error.emptyResultError);
}

class InputFailure extends Failure {
  InputFailure([String? msg]) : super(msg ?? AppMessages.error.inputError);
}

class InvalidDate extends Failure {
  InvalidDate([String? msg]) : super(msg ?? AppMessages.error.invalidDateError);
}

class InvalidEmail extends Failure {
  InvalidEmail([String? msg])
    : super(msg ?? AppMessages.error.invalidEmailError);
}

class InvalidPassword extends Failure {
  InvalidPassword([String? msg])
    : super(msg ?? AppMessages.error.invalidPasswordError);
}

class PasswordNotConfirmed extends Failure {
  PasswordNotConfirmed([String? msg])
    : super(msg ?? AppMessages.error.passwordMismatchError);
}

class InvalidPhone extends Failure {
  InvalidPhone([String? msg])
    : super(msg ?? AppMessages.error.invalidPhoneError);
}
