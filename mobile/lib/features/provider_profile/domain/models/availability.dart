class DayAvailability {
  final bool isAvailable;
  final String? startTime;
  final String? endTime;

  DayAvailability({
    required this.isAvailable,
    this.startTime,
    this.endTime,
  });

  DayAvailability copyWith({
    bool? isAvailable,
    String? startTime,
    String? endTime,
  }) {
    return DayAvailability(
      isAvailable: isAvailable ?? this.isAvailable,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }

  factory DayAvailability.fromJson(Map<String, dynamic> json) {
    return DayAvailability(
      isAvailable: json['isAvailable'],
      startTime: json['startTime'],
      endTime: json['endTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isAvailable': isAvailable,
      'startTime': startTime,
      'endTime': endTime,
    };
  }
}
