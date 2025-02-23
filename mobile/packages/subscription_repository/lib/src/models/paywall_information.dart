import 'package:equatable/equatable.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:subscription_repository/src/models/models.dart';

class PayWallInformation extends Equatable {
  final List<Package> subscriptions;
  final PayMetadata metadata;
  final bool isLoaded;

  PayWallInformation({
    required this.subscriptions,
    required this.metadata,
    required this.isLoaded,
  });

  static PayWallInformation fromOffering(Offering offering) {
    final List<Package> subscriptions = offering.availablePackages
        .where((package) => package.storeProduct.subscriptionOptions != null)
        .toList();
    subscriptions
        .sort((a, b) => a.storeProduct.price.compareTo(b.storeProduct.price));

    return PayWallInformation(
      subscriptions: subscriptions,
      metadata: PayMetadata.fromJson(offering.metadata),
      isLoaded: true,
    );
  }

  static PayWallInformation loadDefault() {
    return PayWallInformation(
        subscriptions: const [],
        metadata: PayMetadata.fromJson({}),
        isLoaded: false);
  }

  @override
  List<Object?> get props => [subscriptions, metadata];
}
