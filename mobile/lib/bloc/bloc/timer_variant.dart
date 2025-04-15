enum TimerVariant { pomodoro, fiftyTwoSeventeen, endless, ninetyThirty }

extension TimerVariantExtension on TimerVariant {
  bool get hasPause {
    switch (this) {
      case TimerVariant.pomodoro:
        return true;
      case TimerVariant.fiftyTwoSeventeen:
        return true;
      case TimerVariant.ninetyThirty:
        return true;
      case TimerVariant.endless:
        return false;
    }
  }

  String get name {
    switch (this) {
      case TimerVariant.pomodoro:
        return 'Pomodoro';
      case TimerVariant.fiftyTwoSeventeen:
        return '52:17';
      case TimerVariant.ninetyThirty:
        return '90:30';
      case TimerVariant.endless:
        return 'Endless';
    }
  }

  String get description {
    switch (this) {
      case TimerVariant.pomodoro:
        return '25 minutes of work followed by a 5-minute break.';
      case TimerVariant.fiftyTwoSeventeen:
        return '52 minutes of work followed by a 17-minute break.';
      case TimerVariant.ninetyThirty:
        return '90 minutes of work followed by a 30-minute break.';
      case TimerVariant.endless:
        return 'No time limit, work at your own pace.';
    }
  }

  String get icon {
    switch (this) {
      case TimerVariant.pomodoro:
        return '🍅';
      case TimerVariant.fiftyTwoSeventeen:
        return '⏳';
      case TimerVariant.ninetyThirty:
        return '🕒';
      case TimerVariant.endless:
        return '♾️';
    }
  }

  Duration getWorkDuration() {
    switch (this) {
      case TimerVariant.pomodoro:
        return const Duration(minutes: 25);
      case TimerVariant.ninetyThirty:
        return const Duration(minutes: 90);
      case TimerVariant.fiftyTwoSeventeen:
        return const Duration(minutes: 52);
      case TimerVariant.endless:
        return const Duration(hours: 4);
    }
  }

  Duration getBreakDuration() {
    switch (this) {
      case TimerVariant.pomodoro:
        return const Duration(minutes: 5);
      case TimerVariant.ninetyThirty:
        return const Duration(minutes: 30);
      case TimerVariant.fiftyTwoSeventeen:
        return const Duration(minutes: 17);
      case TimerVariant.endless:
        return Duration.zero;
    }
  }
}
