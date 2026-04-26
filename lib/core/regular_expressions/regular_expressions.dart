abstract class RegexApp {
  // apenas dígitos
  static final onlyNumbers = RegExp(r'[0-9]');

  // email
  static final email = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  // telefone no formato +1122333334444
  // +11 pais com dois dígitos
  // 22 DDD com dois dígitos
  // 33333 bloco de 3 a 5 dígitos
  // 4444 bloco com 4 dígitos
  static final phone = RegExp(r'^\+\d{2}\d{2}\d{3,5}\d{4}$');
  
  // Ao menos 1 caracter maiusculo
  // Ao menos 1 caracter minúsculo
  // Ao menos 1 digito
  // Ao menos 1 caracter especial
  static final password = RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>]).*$');
  
  // Ao menos 1 caracter maiusculo
  static final hasLowerCase = RegExp(r'(?=.*[a-z])');

  // Ao menos 1 caracter minúsculo
  static final hasUpperCase = RegExp(r'(?=.*[A-Z])');
  
  // Ao menos 1 digito
  static final hasDigit = RegExp(r'(?=.*\d)');

  // Ao menos 1 caracter especial
  static final hasSpecialChar = RegExp(r'(?=.*[!@#$%^&*(),.?":{}|<>])');
}
