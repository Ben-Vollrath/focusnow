import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:subscription_repository/subscription_repository.dart';

part 'subscription_events.dart';
part 'subscription_state.dart';

class SubscriptionBloc
    extends HydratedBloc<SubscriptionEvent, SubscriptionState> {
  SubscriptionBloc(this._subscriptionRepository)
      : super(SubscriptionState.inactive()) {
    on<LoadSubscription>(_onLoadSubscription);
    on<SubscriptionUpdated>(_onSubscriptionUpdated);
    on<LogOut>(_onLogOut);

    // Listen to the subscription stream and update the state when it changes
    _subscriptionRepository.subscriptionStream.listen((subscription) {
      add(SubscriptionUpdated(subscription));
    });
  }

  final SubscriptionRepository _subscriptionRepository;

  Future<void> _onSubscriptionUpdated(
      SubscriptionUpdated event, Emitter<SubscriptionState> emit) async {
    emit(event.subscription.isActive
        ? SubscriptionState.active()
        : SubscriptionState.inactive());
  }

  Future<void> _onLoadSubscription(
      LoadSubscription event, Emitter<SubscriptionState> emit) async {
    if (event.userId != null) {
      await _subscriptionRepository.configurePurchases(event.userId!);
    }
    final Subscription subscription =
        await _subscriptionRepository.getUserSubscription();
    emit(subscription.isActive
        ? SubscriptionState.active()
        : SubscriptionState.inactive());
  }

  Future<void> _onLogOut(LogOut event, Emitter<SubscriptionState> emit) async {
    await _subscriptionRepository.logOut();

    emit(SubscriptionState.inactive());
  }

  @override
  SubscriptionState? fromJson(Map<String, dynamic> json) {
    return json['isActive'] == true
        ? SubscriptionState.active()
        : SubscriptionState.inactive();
  }

  @override
  Map<String, dynamic>? toJson(SubscriptionState state) {
    return {'isActive': state.status == SubscriptionStatus.active};
  }
}
