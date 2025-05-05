import 'package:flutter/material.dart';
import 'package:study_group_repository/input_goal.dart';

class GoalInputSheet extends StatefulWidget {
  const GoalInputSheet({super.key});

  @override
  State<GoalInputSheet> createState() => _GoalInputSheetState();
}

class _GoalInputSheetState extends State<GoalInputSheet> {
  final _formKey = GlobalKey<FormState>();
  final _targetController = TextEditingController();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _dueDate;

  void _setQuickHours(int hours) {
    _targetController.text = hours.toString();
  }

  @override
  void dispose() {
    _targetController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
                  color: colorScheme.outline,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            Row(
              children: [
                Icon(Icons.flag_outlined, size: 24, color: colorScheme.primary),
                const SizedBox(width: 8),
                const Text(
                  'Set your Goal',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Goal Name'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Enter a name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 2,
            ),
            TextFormField(
              controller: _targetController,
              decoration: const InputDecoration(labelText: 'Target Hours'),
              keyboardType: TextInputType.number,
              validator: (value) {
                final num = double.tryParse(value ?? '');
                if (num == null || num <= 0) return 'Enter valid hours';
                return null;
              },
            ),
            Wrap(
              spacing: 8,
              children: [25, 50, 100].map((h) {
                return OutlinedButton(
                  onPressed: () => _setQuickHours(h),
                  child: Text('$h h'),
                );
              }).toList(),
            ),
            _EmbeddedDatePicker(
              selectedDate: _dueDate,
              onChanged: (date) => setState(() => _dueDate = date),
              onClear: () => setState(() => _dueDate = null),
            ),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        final hours = double.parse(_targetController.text);
                        final minutes = (hours * 60).round();
                        final input = InputGoal(
                          name: _nameController.text.trim(),
                          description: _descriptionController.text.trim(),
                          targetMinutes: minutes,
                          targetDate: _dueDate,
                        );
                        Navigator.pop(context, input);
                      }
                    },
                    child: const Text('Create'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _EmbeddedDatePicker extends StatelessWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onChanged;
  final VoidCallback onClear;

  const _EmbeddedDatePicker({
    required this.selectedDate,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Due Date (optional)',
                style: Theme.of(context).textTheme.labelMedium),
            const Spacer(),
            TextButton(
              onPressed: selectedDate != null ? onClear : null,
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              child: const Text('Remove'),
            ),
          ],
        ),
        CalendarDatePicker(
          initialDate: selectedDate ?? now,
          firstDate: now,
          lastDate: now.add(const Duration(days: 365)),
          onDateChanged: onChanged,
        ),
      ],
    );
  }
}
