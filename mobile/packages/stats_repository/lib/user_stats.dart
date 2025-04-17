class UserStats {
  final int level;
  final int xp;
  final int? xpToNext; // null if max level
  final String levelName;
  final String? levelIcon;
  final int totalStudyTime;
  final int totalStudySessions;

  UserStats({
    required this.level,
    required this.xp,
    required this.xpToNext,
    required this.levelName,
    required this.levelIcon,
    required this.totalStudyTime,
    required this.totalStudySessions,
  });

  factory UserStats.fromMap(Map<String, dynamic> map) {
    return UserStats(
      level: map['level'] as int,
      xp: map['xp'] as int,
      xpToNext: map['xpToNext'] as int?,
      levelName: map['levelName'] as String,
      levelIcon: map['levelIcon'] as String?,
      totalStudyTime: map['totalStudyTime'] as int,
      totalStudySessions: map['totalStudySessions'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'level': level,
      'xp': xp,
      'xpToNext': xpToNext,
      'levelName': levelName,
      'levelIcon': levelIcon,
      'totalStudyTime': totalStudyTime,
      'totalStudySessions': totalStudySessions,
    };
  }
}
