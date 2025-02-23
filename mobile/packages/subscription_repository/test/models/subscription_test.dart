import 'package:flutter_test/flutter_test.dart';
import 'package:subscription_repository/subscription_repository.dart';

void main() {
  group('Subscription', () {
    test('support value comparison', () {
      expect(
        const Subscription(isPremium: true, credits: 10, isMonthly: true),
        equals(
            const Subscription(isPremium: true, credits: 10, isMonthly: true)),
      );
    });

    test('supports copywith', () {
      expect(
        const Subscription(isPremium: true, credits: 10, isMonthly: true)
            .copyWith(credits: 20),
        equals(
            const Subscription(isPremium: true, credits: 20, isMonthly: true)),
      );
    });
  });
}
