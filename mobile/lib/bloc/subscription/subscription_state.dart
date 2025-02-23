part of 'subscription_bloc.dart';

enum SubscriptionStatus {
  active,
  inactive,
}

final class SubscriptionState extends Equatable {
  const SubscriptionState._({
    required this.status,
  });

  const SubscriptionState.active() : this._(status: SubscriptionStatus.active);

  const SubscriptionState.inactive()
      : this._(status: SubscriptionStatus.inactive);

  final SubscriptionStatus status;

  @override
  List<Object> get props => [status];
}
