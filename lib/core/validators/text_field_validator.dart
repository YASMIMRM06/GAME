import 'base_validator.dart';

class TextFieldValidator {
  final List<BaseValidator> _validators;

  TextFieldValidator({required List<BaseValidator> validators})
      : _validators = validators;

  bool validations(String? validation) {

    for (var i = 0; i < _validators.length-1; i++) {
      _validators[i].setNextValidator(_validators[i + 1]);
    }

    return _validators[0].validate(validation);
  }
}
