import 'package:flutter_test/flutter_test.dart';
import 'validation.dart';

void main() {
  // Agrupar las pruebas relacionadas en un grupo llamado 'Validation tests'
  group('Validation tests', () {

    // Prueba para validar el funcionamiento correcto de la validación de correo electrónico
    test('Email validation works correctly', () {
      print('Testing email validation');
      // Verificar si el correo electrónico es válido
      expect(Validation.isEmailValid('test@example.com'), true);
      // Verificar si el correo electrónico es inválido
      expect(Validation.isEmailValid('test@.com'), false);
    });

    // Prueba para validar el funcionamiento correcto de la validación del número de teléfono
    test('Phone number validation works correctly', () {
      print('Testing phone number validation');
      // Verificar si el número de teléfono es válido
      expect(Validation.isPhoneNumberValid('612345678'), true);
      // Verificar si el número de teléfono es inválido
      expect(Validation.isPhoneNumberValid('123456789'), false);
    });

    // Prueba para validar el funcionamiento correcto de la validación de la fortaleza de la contraseña
    test('Password strength validation works correctly', () {
      print('Testing password strength validation');
      // Verificar si la contraseña es lo suficientemente fuerte
      expect(Validation.isPasswordStrongEnough('123456'), true);
      // Verificar si la contraseña no es lo suficientemente fuerte
      expect(Validation.isPasswordStrongEnough('1234'), false);
    });

    // Prueba para validar el funcionamiento correcto de la validación de confirmación de contraseña
    test('Password confirmation validation works correctly', () {
      print('Testing password confirmation validation');
      // Verificar si las contraseñas coinciden
      expect(Validation.passwordConfirmed('password', 'password'), true);
      // Verificar si las contraseñas no coinciden
      expect(Validation.passwordConfirmed('password', 'passworD'), false);
    });
  });
}
