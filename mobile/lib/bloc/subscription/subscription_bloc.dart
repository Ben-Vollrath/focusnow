import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscription_repository/subscription_repository.dart';

part 'subscription_events.dart';
part 'subscription_state.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  SubscriptionBloc(this._subscriptionRepository)
      : super(SubscriptionInitial()) {
    on<LoadSubscription>(_onLoadSubscription);
    on<SubscriptionUpdated>(_onSubscriptionUpdated);

    // Listen to the subscription stream and update the state when it changes
    _subscriptionRepository.subscriptionStream.listen((subscription) {
      add(SubscriptionUpdated(subscription));
    });
  }

  final SubscriptionRepository _subscriptionRepository;

  Future<void> _onSubscriptionUpdated(
      SubscriptionUpdated event, Emitter<SubscriptionState> emit) async {
    emit(SubscriptionLoaded(event.subscription));
  }

  Future<void> _onLoadSubscription(
      LoadSubscription event, Emitter<SubscriptionState> emit) async {
    emit(SubscriptionLoading());
    try {
      if (event.userId != null) {
        await _subscriptionRepository.configurePurchases(event.userId!);
      }
      final Subscription subscription =
          await _subscriptionRepository.getUserSubscription();
      emit(SubscriptionLoaded(subscription));
    } catch (e) {
      emit(SubscriptionError(e.toString()));
    }
  }
}
