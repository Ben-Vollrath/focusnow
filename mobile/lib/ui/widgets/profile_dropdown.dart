import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusnow/bloc/app/app_bloc.dart';
import 'package:focusnow/ui/login/login_page.dart';
import 'package:focusnow/ui/user_management/user_management_page.dart';

class ProfileDropdownButton extends StatelessWidget {
  const ProfileDropdownButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return PopupMenuButton<String>(
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Theme.of(context).colorScheme.surface,
                foregroundColor: Theme.of(context).colorScheme.onSurface,
                child: Icon(Icons.person),
              ),
              if (state.user.isAnonymous)
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: const Center(
                      child: Text(
                        '!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onSelected: (value) {
            switch (value) {
              case 'login':
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
                break;
              case 'logout':
                context.read<AppBloc>().add(AppLogoutRequested());
                break;
              case 'settings':
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserManagementPage(),
                  ),
                );
                break;
            }
          },
          itemBuilder: (BuildContext context) => [
            PopupMenuItem(
              value: "settings",
              child: Row(
                children: const [
                  Icon(Icons.settings, size: 20),
                  SizedBox(width: 8),
                  Text('Manage Account'),
                ],
              ),
            ),
            if (state.user.isAnonymous)
              PopupMenuItem(
                value: 'login',
                child: Column(
                  children: [
                    Text(
                      'Create an Account to save your progress!',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Theme.of(context).colorScheme.error),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: const [
                        Icon(Icons.login, size: 20),
                        SizedBox(width: 8),
                        Text('Create Account'),
                      ],
                    ),
                  ],
                ),
              ),
            PopupMenuItem(
              value: 'logout',
              child: Row(
                children: const [
                  Icon(Icons.logout, size: 20),
                  SizedBox(width: 8),
                  Text('Logout'),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
