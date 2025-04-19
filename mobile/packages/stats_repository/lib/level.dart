import 'package:equatable/equatable.dart';

class Level extends Equatable {
  final int level;
  final String name;
  final String icon;
  final int xpRequired;

  const Level({
    required this.level,
    required this.name,
    required this.icon,
    required this.xpRequired,
  });

  @override
  List<Object?> get props => [level, name, icon, xpRequired];

  factory Level.fromJson(Map<String, dynamic> json) {
    return Level(
      level: json['level'] as int,
      name: json['name'] as String,
      icon: json['icon'] as String,
      xpRequired: json['xp_required'] as int,
    );
  }
}
