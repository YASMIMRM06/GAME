/// validador base para ser extendido
/// por outros validadores
library;

abstract base class BaseValidator<T> {
  BaseValidator? _nextValidator;
  void setNextValidator(BaseValidator validator) => _nextValidator = validator;
  BaseValidator? get nextValidator => _nextValidator;
  bool validate(T validation);
}
