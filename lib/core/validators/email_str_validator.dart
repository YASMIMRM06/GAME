import '../failure/failure.dart';
import '../messages/app_messages.dart';
import '../regular_expressions/regular_expressions.dart';

import 'base_validator.dart';

/// Validador de email usando expressão regular
final class EmailStrValidator extends BaseValidator<String?> {
  EmailStrValidator();

  @override
  bool validate(String? validation) {
    return switch (validation) {
      null => throw InputFailure(AppMessages.error.nullStringError),
      String v when v.trim().isEmpty => throw InputFailure(
        AppMessages.error.nullStringError,
      ),
      String v when !RegexApp.email.hasMatch(v.trim()) => throw InvalidEmail(
        AppMessages.error.invalidEmailError,
      ),
      _ => nextValidator?.validate(validation) ?? true,
    };
  }
}
