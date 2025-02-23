import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:subscription_repository/src/models/models.dart';

class MockOffering extends Mock implements Offering {}

class MockPackage extends Mock implements Package {}

class MockStoreProduct extends Mock implements StoreProduct {}

void main() {
  group('PaywallInformation', () {
    late MockOffering mockOffering;
    late MockPackage mockPackage;
    late MockStoreProduct mockStoreProduct;

    // Sample metadata for testing
    final mockMetadata = {
      'titleSub': 'Test Title',
      'titlePackages': 'Test Packages',
      'featureListSub': ['feature1', 'feature2'],
      'featureListPackages': ['feature1', 'feature2'],
      'imageUrlSub': 'https://example.com',
      'imageUrlPackages': 'https://example.com',
      'actionButtonText': 'Subscribe Now',
    };

    setUp(() {
      mockOffering = MockOffering();
      mockPackage = MockPackage();
      mockStoreProduct = MockStoreProduct();

      when(() => mockPackage.storeProduct.subscriptionOptions).thenReturn(null);
      when(() => mockPackage.storeProduct.price).thenReturn(10.0);
      when(() => mockPackage.storeProduct).thenReturn(mockStoreProduct);

      // Mock the metadata and availablePackages in Offering
      when(() => mockOffering.metadata).thenReturn(mockMetadata);
      when(() => mockOffering.availablePackages).thenReturn([mockPackage]);
    });

    test('fromOffering creates PaywallInformation as expected', () {
      final result = PayWallInformation.fromOffering(mockOffering);

      // Validate that metadata is parsed correctly
      expect(result.metadata.titleSub, mockMetadata['titleSub']);
      expect(result.metadata.titlePackages, mockMetadata['titlePackages']);
      expect(result.metadata.featureListSub, mockMetadata['featureListSub']);
      expect(result.metadata.featureListPackages,
          mockMetadata['featureListPackages']);
      expect(result.metadata.imageUrlSub, mockMetadata['imageUrlSub']);
      expect(
          result.metadata.imageUrlPackages, mockMetadata['imageUrlPackages']);
      expect(
          result.metadata.actionButtonText, mockMetadata['actionButtonText']);

      // Validate that packages are assigned correctly
      expect(result.packs, [mockPackage]);
    });
  });
}
