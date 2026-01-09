import 'package:sweater/features/sweatering/model/sweateringstatus.dart';
import 'package:sweater/models/sport.dart';

class Sweateringbottomsheet {
  final Sweateringstatus state;
  final List<Sport> sport;
  final DateTime? startedTime;
  final DateTime? endedTime;

  Sweateringbottomsheet({
    required this.state,
     required this.sport, 
     this.startedTime,
     this.endedTime,
  });

  Sweateringbottomsheet copyWith({
    Sweateringstatus? state,
    List<Sport>? sport,
    DateTime? startedTime,
    DateTime? endedTime,
  }) {
    return Sweateringbottomsheet(
      state: state ?? this.state,
      sport: sport ?? this.sport,
      startedTime: startedTime ?? this.startedTime,
      endedTime: endedTime ?? this.endedTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'state': state.name,
      'sport': sport.map((s) => s.id).toList(),
      'startedTime': startedTime?.toIso8601String(),
      'endedTime': endedTime?.toIso8601String(),
    };
  }

  factory Sweateringbottomsheet.fromMap(Map<String, dynamic> map) {
    return Sweateringbottomsheet(
      state: Sweateringstatus.values.firstWhere(
        (e) => e.name == map['state'],
        orElse: () => Sweateringstatus.none,
      ),
      sport: (
        map['sport'] as List<dynamic>).map((id) 
        => sportsList.firstWhere((s) => s.id == id)).toList(),
      startedTime: map['startedTime'] != null ? DateTime.parse(map['startedTime']) : null,
      endedTime: map['endedTime'] != null ? DateTime.parse(map['endedTime']) : null,
    );
  }
}


