class Validation {
  static bool isEmailValid(String email) {
    RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegExp.hasMatch(email);
  }

  static bool isPhoneNumberValid(String phone) {
    RegExp phoneRegExp = RegExp(r'^[67]\d{8}$');
    return phoneRegExp.hasMatch(phone);
  }

  static bool isPasswordStrongEnough(String password) {
    return password.length >= 6;
  }

  static bool passwordConfirmed(String password, String confirmPassword) {
    return password == confirmPassword;
  }
}
