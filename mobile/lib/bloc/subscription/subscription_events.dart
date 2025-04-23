part of 'subscription_bloc.dart';

abstract class SubscriptionEvent extends Equatable {
  const SubscriptionEvent();

  @override
  List<Object> get props => [];
}

class LoadSubscription extends SubscriptionEvent {
  final String? userId;

  const LoadSubscription({this.userId});
}

class DecreaseCredits extends SubscriptionEvent {
  final int amount;

  const DecreaseCredits(this.amount);

  @override
  List<Object> get props => [amount];
}

class SubscriptionUpdated extends SubscriptionEvent {
  final Subscription subscription;

  const SubscriptionUpdated(this.subscription);

  @override
  List<Object> get props => [subscription];
}

class LogOut extends SubscriptionEvent {}
