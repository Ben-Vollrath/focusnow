import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusnow/bloc/goal/goal_bloc.dart';
import 'package:focusnow/ui/widgets/duration_text.dart';
import 'package:focusnow/ui/widgets/flat_container.dart';
import 'package:focusnow/ui/widgets/rounded_progress_indicator.dart';
import 'package:focusnow/ui/widgets/xp_badge.dart';
import 'package:goal_repository/goal.dart';
import 'package:intl/intl.dart';

class GoalBox extends StatelessWidget {
  const GoalBox({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return FlatContainer(
      child: BlocBuilder<GoalBloc, GoalState>(
        builder: (context, state) {
          final goal = state.goal;
          final isExpired = goal?.targetDate?.isBefore(DateTime.now()) ?? false;

          return switch (state.status) {
            GoalStatus.loading ||
            GoalStatus.initial =>
              const Center(child: CircularProgressIndicator()),
            GoalStatus.error =>
              Text('Error: ${'Something went wrong, try again later'}'),
            GoalStatus.loaded when goal == null || isExpired => Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Create Goal'),
                  onPressed: () async {
                    final input = await showModalBottomSheet<InputGoal>(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (context) => const GoalInputSheet(),
                    );
                    if (input != null) {
                      context.read<GoalBloc>().add(CreateGoal(input));
                    }
                  },
                ),
              ),
            _ => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.flag_outlined,
                        size: 24,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text('Goal', style: textTheme.titleMedium),
                      const SizedBox(width: 12),
                      XpBadge(text: '${goal!.xpReward} XP'),
                      Spacer(),
                      IconButton(
                          onPressed: () => context
                              .read<GoalBloc>()
                              .add(DeleteGoal(goal!.id)),
                          icon: Icon(
                            Icons.delete,
                            color: Theme.of(context).colorScheme.error,
                          ))
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (goal.targetDate != null)
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          'Due: ${DateFormat.yMMMd().format(goal.targetDate!)}',
                          style: textTheme.bodySmall,
                        ),
                      ],
                    ),
                  const SizedBox(height: 8),
                  RoundedProgressIndicator(
                    progress: goal.currentMinutes,
                    fullAmount: goal.targetMinutes,
                    textLeft: 'Goal Progress',
                    textRight: Row(
                      children: [
                        DurationText(
                            minutes: goal.currentMinutes,
                            showUnit: false,
                            style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withAlpha(200))),
                        Text(' / ',
                            style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withAlpha(200))),
                        DurationText(
                            minutes: goal.targetMinutes,
                            style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withAlpha(200)))
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
          };
        },
      ),
    );
  }
}

class GoalInputSheet extends StatefulWidget {
  const GoalInputSheet({super.key});

  @override
  State<GoalInputSheet> createState() => _GoalInputSheetState();
}

class _GoalInputSheetState extends State<GoalInputSheet> {
  final _formKey = GlobalKey<FormState>();
  final _targetController = TextEditingController();
  DateTime? _dueDate;

  void _setQuickHours(int hours) {
    _targetController.text = hours.toString();
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
                  color: Theme.of(context).colorScheme.outline,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            Row(
              children: [
                Icon(
                  Icons.flag_outlined,
                  size: 24,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 8),
                const Text('Create Goal',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
              ],
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
                          name: "My Goal",
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
