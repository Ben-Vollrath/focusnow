import 'package:flutter_test/flutter_test.dart';
import 'package:subscription_repository/subscription_repository.dart';

void main() {
  group('MetaData', () {
    // Define expected values for comparison
    const expectedTitleSub = 'Sub Title';
    const expectedTitlePackages = 'Packages Title';
    const expectedFeatureListSub = ['feature1', 'feature2'];
    const expectedFeatureListPackages = ['feature1', 'feature2'];
    const expectedImageUrlSub = 'https://example.com';
    const expectedImageUrlPackages = 'https://example.com';
    const expectedActionButtonText = 'Buy';

    // Define test metadata
    final testMetaData = {
      'titleSub': expectedTitleSub,
      'titlePackages': expectedTitlePackages,
      'featureListSub': expectedFeatureListSub,
      'featureListPackages': expectedFeatureListPackages,
      'imageUrlSub': expectedImageUrlSub,
      'imageUrlPackages': expectedImageUrlPackages,
      'actionButtonText': expectedActionButtonText,
    };

    test('FromJson parses values as expected', () {
      final parsedMetadata = PayMetadata.fromJson(testMetaData);

      // Use `expect` for assertions
      expect(parsedMetadata.titleSub, expectedTitleSub);
      expect(parsedMetadata.titlePackages, expectedTitlePackages);
      expect(parsedMetadata.featureListSub, expectedFeatureListSub);
      expect(parsedMetadata.featureListPackages, expectedFeatureListPackages);
      expect(parsedMetadata.imageUrlSub, expectedImageUrlSub);
      expect(parsedMetadata.imageUrlPackages, expectedImageUrlPackages);
      expect(parsedMetadata.actionButtonText, expectedActionButtonText);
    });
  });
}
