class PayMetadata {
  final String titleSub;
  final String titlePackages;

  final List<String> featureListSub;
  final List<String> featureListPackages;

  final String? imageUrlSub;
  final String? imageUrlPackages;

  final List<String?> packShowcaseImages;

  final String? actionButtonText;

  PayMetadata({
    this.titleSub = "Transform your Homescreen",
    this.titlePackages = "Transform your Homescreen",
    this.featureListSub = const [],
    this.featureListPackages = const [],
    this.packShowcaseImages = const [],
    this.imageUrlSub,
    this.imageUrlPackages,
    this.actionButtonText = "Continue",
  });

  static PayMetadata fromJson(Map<String, dynamic> json) {
    return PayMetadata(
      titleSub: json['titleSub'] as String? ?? "Transform your Homescreen",
      titlePackages:
          json['titlePackages'] as String? ?? "Transform your Homescreen",
      featureListSub: (json['featureListSub'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [
            "Generous Monthly Icon Limit",
            "Ad Free",
            "Lightning Fast Icon Generation"
          ],
      featureListPackages: (json['featureListPackages'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          ["Ad Free", "Lightning Fast Icon Generation"],
      packShowcaseImages: (json['packShowcaseImages'] as List<dynamic>?)
              ?.map((e) => e as String?)
              .toList() ??
          [],
      imageUrlSub: json['imageUrlSub'] as String?,
      imageUrlPackages: json['imageUrlPackages'] as String?,
      actionButtonText: json['actionButtonText'] as String?,
    );
  }
}
