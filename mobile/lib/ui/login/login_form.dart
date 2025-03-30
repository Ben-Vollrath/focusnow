import 'package:authentication_repository/authentication_repository.dart';
import 'package:focusnow/bloc/app/app_bloc.dart';
import 'package:focusnow/bloc/login/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<LoginCubit>().refreshSession();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppBloc, AppState>(
      listener: (context, state) {
        if (state.status == AppStatus.authenticated) {
          Navigator.pop(context);
        }
      },
      child: BlocListener<LoginCubit, LoginState>(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) {
          if (state.status.isFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? 'Authentication Failure'),
                ),
              );
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              Image.asset(
                'assets/ic_launcher_round.webp',
                height: 120,
              ),
              const SizedBox(height: 16),
              Text('Continue to sign up for free',
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                      )),
              const SizedBox(height: 16),
              const Text('If you already have an account, we\'ll log you in'),
              const SizedBox(height: 16),
              _EmailInput(),
              _LoginButton(),
              const SizedBox(height: 16),
              _FormDivider(),
              const SizedBox(height: 16),
              _GoogleLoginButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _FormDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Row(
      children: <Widget>[
        Expanded(
          child: Divider(
            thickness: 1.0,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text("or"),
        ),
        Expanded(
          child: Divider(
            thickness: 1.0,
          ),
        ),
      ],
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_emailInput_textField'),
          onChanged: (email) => context.read<LoginCubit>().emailChanged(email),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
            filled: true,
            labelText: 'Email',
            helperText: '',
            errorText:
                state.email.displayError != null ? 'invalid email' : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return state.emailSent
            ? Text('Check your email for your login link!')
            : state.status.isInProgress
                ? const CircularProgressIndicator()
                : Row(
                    children: [
                      Expanded(
                        child: FilledButton(
                          key: const Key('loginForm_continue_raisedButton'),
                          onPressed: state.isValid
                              ? () {
                                  User currentUser =
                                      context.read<AppBloc>().state.user;
                                  if (currentUser.isAnonymous) {
                                    context.read<LoginCubit>().linkEmailAuth();
                                  } else {
                                    context
                                        .read<LoginCubit>()
                                        .logInWithMagicLink();
                                  }
                                }
                              : null,
                          child: const Text('SIGN UP'),
                        ),
                      ),
                    ],
                  );
      },
    );
  }
}

class _GoogleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
              key: const Key('loginForm_googleLogin_raisedButton'),
              label: Text(
                'Continue with Google',
                style: TextStyle(color: theme.colorScheme.outline),
              ),
              icon: Image.asset(
                'assets/google_logo.png',
                height: 24.0,
                width: 24.0,
              ),
              style: ElevatedButton.styleFrom(
                side: const BorderSide(
                    color: Colors.black, width: 1), // Black border
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onPressed: () {
                User currentUser = context.read<AppBloc>().state.user;
                if (currentUser.isAnonymous) {
                  context.read<LoginCubit>().linkGoogleAuth();
                } else {
                  context.read<LoginCubit>().logInWithGoogle();
                }
              }),
        ),
      ],
    );
  }
}
