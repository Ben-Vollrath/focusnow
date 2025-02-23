import 'package:flutter_test/flutter_test.dart';
import 'package:focusnow/bloc/login/login_cubit.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';

void main() {
  const email = Email.dirty('email');
  const password = Password.dirty('password');

  group('LoginState', () {
    test('supports value comparisons', () {
      expect(LoginState(), LoginState());
    });

    test('returns same object when no properties are passed', () {
      expect(LoginState().copyWith(), LoginState());
    });

    test('returns object with updated status when status is passed', () {
      expect(
        LoginState().copyWith(status: FormzSubmissionStatus.initial),
        LoginState(),
      );
    });

    test('returns object with updated email when email is passed', () {
      expect(
        LoginState().copyWith(email: email),
        LoginState(email: email),
      );
    });

    test('returns object with updated emailSent flag when emailSent is passed',
        () {
      expect(
        LoginState().copyWith(emailSent: true),
        LoginState(emailSent: true),
      );
    });
  });
}
