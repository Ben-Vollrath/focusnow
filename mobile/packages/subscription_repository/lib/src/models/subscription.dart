import 'package:equatable/equatable.dart';

class Subscription extends Equatable {
  final bool isPremium;
  final int credits;
  final bool isMonthly;

  const Subscription(
      {required this.isPremium,
      required this.credits,
      required this.isMonthly});

  @override
  List<Object?> get props => [isPremium, credits];

  String get displayName => isPremium ? 'Premium' : 'Free';

  String get limit => isPremium
      ? isMonthly
          ? '2000/month'
          : '500/week'
      : '3/day';

  //Copy with
  Subscription copyWith({bool? isPremium, int? credits, bool? isMonthly}) {
    return Subscription(
        isPremium: isPremium ?? this.isPremium,
        credits: credits ?? this.credits,
        isMonthly: isMonthly ?? this.isMonthly);
  }
}
