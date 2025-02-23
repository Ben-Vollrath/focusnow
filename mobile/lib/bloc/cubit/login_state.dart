part of 'login_cubit.dart';

final class LoginState extends Equatable {
  const LoginState({
    this.email = const Email.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.errorMessage,
    this.emailSent = false,
  });

  final Email email;
  final FormzSubmissionStatus status;
  final bool isValid;
  final String? errorMessage;
  final bool emailSent;

  @override
  List<Object?> get props => [email, status, isValid, errorMessage];

  LoginState copyWith({
    Email? email,
    Password? password,
    FormzSubmissionStatus? status,
    bool? isValid,
    String? errorMessage,
    bool? emailSent
  }) {
    return LoginState(
      email: email ?? this.email,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
      emailSent: emailSent ?? this.emailSent,
    );
  }
}