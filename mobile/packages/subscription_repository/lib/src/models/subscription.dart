import 'package:equatable/equatable.dart';

class Subscription extends Equatable {
  final bool isActive;

  const Subscription({required this.isActive});

  @override
  List<Object?> get props => [isActive];

  static const Subscription inactive = Subscription(isActive: false);

  //Copy with
  Subscription copyWith({bool? isActive}) {
    return Subscription(isActive: isActive ?? this.isActive);
  }
}
