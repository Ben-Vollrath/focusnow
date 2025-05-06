import 'package:analytics_repository/analytics_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusnow/bloc/user/user_bloc.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  final TextEditingController _confirmationController = TextEditingController();
  bool _isConfirmed = false;

  @override
  void initState() {
    super.initState();
    _confirmationController.addListener(_onTextChanged);
    AnalyticsRepository().logScreen("user_management_page");
  }

  void _onTextChanged() {
    setState(() {
      _isConfirmed =
          _confirmationController.text.trim().toLowerCase() == 'delete';
    });
  }

  @override
  void dispose() {
    _confirmationController.dispose();
    super.dispose();
  }

  void _onDeletePressed() {
    context.read<UserBloc>().add(UserDeleteAccountEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Account Management')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'To delete your account, please type "delete" below and confirm.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _confirmationController,
              decoration: const InputDecoration(
                labelText: 'Type "delete" to confirm',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isConfirmed ? _onDeletePressed : null,
              child: const Text('Delete Account'),
            ),
          ],
        ),
      ),
    );
  }
}
