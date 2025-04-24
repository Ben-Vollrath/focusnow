import 'package:equatable/equatable.dart';

class StudySession extends Equatable {
  const StudySession({required this.startTime, required this.endTime});

  final DateTime startTime;
  final DateTime endTime;

  @override
  List<Object?> get props => [startTime, endTime];

  Map<String, dynamic> toJson() {
    return {
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
    };
  }

  factory StudySession.fromJson(Map<String, dynamic> json) {
    return StudySession(
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
    );
  }
}
