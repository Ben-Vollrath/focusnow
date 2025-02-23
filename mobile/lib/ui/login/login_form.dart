import 'package:focusnow/bloc/cubit/login_cubit.dart';
import 'package:focusnow/ui/login/magic_link.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.emailSent) {
          Navigator.push(
            context,
            MaterialPageRoute(
                settings: const RouteSettings(name: "MagicLinkView"),
                builder: (context) => MagicLinkView()),
          );
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
        return state.status.isInProgress
            ? const CircularProgressIndicator()
            : Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      key: const Key('loginForm_continue_raisedButton'),
                      onPressed: state.isValid
                          ? () =>
                              context.read<LoginCubit>().logInWithMagicLink()
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
            onPressed: () => context.read<LoginCubit>().logInWithGoogle(),
          ),
        ),
      ],
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextButton(
      key: const Key('loginForm_createAccount_flatButton'),
      onPressed: () {},
      child: Text(
        'CREATE ACCOUNT',
        style: TextStyle(color: theme.primaryColor),
      ),
    );
  }
}
