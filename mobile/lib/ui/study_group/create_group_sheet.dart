import 'package:flutter/material.dart';

class StudyGroupInputSheet extends StatefulWidget {
  const StudyGroupInputSheet({super.key});

  @override
  State<StudyGroupInputSheet> createState() => _StudyGroupInputSheetState();
}

class _StudyGroupInputSheetState extends State<StudyGroupInputSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isPublic = true;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        top: 24,
        left: 24,
        right: 24,
      ),
      child: Form(
        key: _formKey,
        child: Wrap(
          runSpacing: 16,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outline,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const Text(
              'Create a Study Group',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            TextFormField(
              controller: _nameController,
              maxLength: 30,
              decoration: const InputDecoration(labelText: 'Group Name'),
              validator: (value) =>
                  value == null || value.trim().isEmpty ? 'Enter a name' : null,
            ),
            TextFormField(
              controller: _descriptionController,
              maxLength: 50,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 1,
            ),
            SwitchListTile(
              value: _isPublic,
              onChanged: (val) => setState(() => _isPublic = val),
              title: const Text('Public Group'),
              subtitle: const Text('Anyone can join if public'),
            ),
            FilledButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  Navigator.pop(context, {
                    'name': _nameController.text.trim(),
                    'description': _descriptionController.text.trim(),
                    'isPublic': _isPublic,
                  });
                }
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}
