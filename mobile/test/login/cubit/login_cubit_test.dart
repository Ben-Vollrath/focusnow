import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusnow/bloc/login/login_cubit.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

void main() {
  const invalidEmailString = 'invalid';
  const invalidEmail = Email.dirty(invalidEmailString);

  const validEmailString = 'test@gmail.com';
  const validEmail = Email.dirty(validEmailString);

  group('LoginCubit', () {
    late AuthenticationRepository authenticationRepository;

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      when(
        () => authenticationRepository.logInWithGoogle(),
      ).thenAnswer((_) async {
        return Future.value(true);
      });
      when(
        () => authenticationRepository.logInWithMagicLink(
          email: any(named: 'email'),
        ),
      ).thenAnswer((_) async {});
    });

    test('initial state is LoginState', () {
      expect(LoginCubit(authenticationRepository).state, LoginState());
    });

    group('emailChanged', () {
      blocTest<LoginCubit, LoginState>(
        'emits [invalid] when email/password are invalid',
        build: () => LoginCubit(authenticationRepository),
        act: (cubit) => cubit.emailChanged(invalidEmailString),
        expect: () => const <LoginState>[LoginState(email: invalidEmail)],
      );

      blocTest<LoginCubit, LoginState>(
        'emits [valid] when email/password are valid',
        build: () => LoginCubit(authenticationRepository),
        seed: () => LoginState(),
        act: (cubit) => cubit.emailChanged(validEmailString),
        expect: () => const <LoginState>[
          LoginState(
            email: validEmail,
            isValid: true,
          ),
        ],
      );
    });

    blocTest<LoginCubit, LoginState>(
      'emits [submissionInProgress, submissionSuccess] '
      'when logInWithMagicLink succeeds',
      build: () => LoginCubit(authenticationRepository),
      seed: () => LoginState(
        email: validEmail,
        isValid: true,
      ),
      act: (cubit) => cubit.logInWithMagicLink(),
      expect: () => const <LoginState>[
        LoginState(
          status: FormzSubmissionStatus.inProgress,
          email: validEmail,
          isValid: true,
        ),
        LoginState(
          status: FormzSubmissionStatus.success,
          email: validEmail,
          isValid: true,
        ),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'emits [submissionInProgress, submissionFailure] '
      'when logInWithMagicLink fails '
      'due to AuthFailure',
      setUp: () {
        when(
          () => authenticationRepository.logInWithMagicLink(
            email: any(named: 'email'),
          ),
        ).thenThrow(AuthFailure());
      },
      build: () => LoginCubit(authenticationRepository),
      seed: () => LoginState(
        email: validEmail,
        isValid: true,
      ),
      act: (cubit) => cubit.logInWithMagicLink(),
      expect: () => const <LoginState>[
        LoginState(
          status: FormzSubmissionStatus.inProgress,
          email: validEmail,
          isValid: true,
        ),
        LoginState(
          status: FormzSubmissionStatus.failure,
          errorMessage: 'An unknown error occurred.',
          email: validEmail,
          isValid: true,
        ),
      ],
    );

    group('logInWithGoogle', () {
      blocTest<LoginCubit, LoginState>(
        'calls logInWithGoogle',
        build: () => LoginCubit(authenticationRepository),
        act: (cubit) => cubit.logInWithGoogle(),
        verify: (_) {
          verify(() => authenticationRepository.logInWithGoogle()).called(1);
        },
      );

      blocTest<LoginCubit, LoginState>(
        'emits [inProgress, success] '
        'when logInWithGoogle succeeds',
        build: () => LoginCubit(authenticationRepository),
        act: (cubit) => cubit.logInWithGoogle(),
        expect: () => const <LoginState>[
          LoginState(status: FormzSubmissionStatus.inProgress),
          LoginState(status: FormzSubmissionStatus.success),
        ],
      );

      blocTest<LoginCubit, LoginState>(
        'emits [inProgress, failure] '
        'when logInWithGoogle fails due to LogInWithGoogleFailure',
        setUp: () {
          when(
            () => authenticationRepository.logInWithGoogle(),
          ).thenThrow(AuthFailure('oops'));
        },
        build: () => LoginCubit(authenticationRepository),
        act: (cubit) => cubit.logInWithGoogle(),
        expect: () => const <LoginState>[
          LoginState(status: FormzSubmissionStatus.inProgress),
          LoginState(
            status: FormzSubmissionStatus.failure,
            errorMessage: 'oops',
          ),
        ],
      );

      blocTest<LoginCubit, LoginState>(
        'emits [inProgress, failure] '
        'when logInWithGoogle fails due to generic exception',
        setUp: () {
          when(
            () => authenticationRepository.logInWithGoogle(),
          ).thenThrow(Exception('oops'));
        },
        build: () => LoginCubit(authenticationRepository),
        act: (cubit) => cubit.logInWithGoogle(),
        expect: () => const <LoginState>[
          LoginState(status: FormzSubmissionStatus.inProgress),
          LoginState(status: FormzSubmissionStatus.failure),
        ],
      );
    });
  });
}
