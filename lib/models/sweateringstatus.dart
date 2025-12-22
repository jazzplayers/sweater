import 'package:sweater/models/sport.dart';


 enum Sweateringstatus{none, sweatering, completed}

int statecode(Sweateringstatus s) {
  switch(s) {
    case Sweateringstatus.none:
      return 10;
    case Sweateringstatus.sweatering:
      return 20;
    case Sweateringstatus.completed:
      return 30;
  }
}

Sweateringstatus statusfromcode(dynamic raw) {
  //raw는 firestore에서 받아오는 값으로 int 또는 String일 수 있음 그래서 dynamic으로 받음
  final code = (raw is int) ? raw : int.tryParse('$raw');
  // (raw is int) raw가 int이면 true 아니면 false
  // A ? B : C  ->  A가 true이면 B를 반환, false이면 C를 반환
  // int.tryParse는 String을 int로 변환 시도, 실패하면 null 반환
  // '$raw'는 raw를 String으로 변환
  switch(code) {
    case 10:
      return Sweateringstatus.none;
    case 20:
      return Sweateringstatus.sweatering;
    case 30:
      return Sweateringstatus.completed;
    default:
      return Sweateringstatus.none;
  }
}

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
      'state': state.index,
      'sport': sport.map((s) => s.id).toList(),
      'startedTime': startedTime?.toIso8601String(),
      'endedTime': endedTime?.toIso8601String(),
    };
  }
  factory Sweateringbottomsheet.fromMap(Map<String, dynamic> map) {
    return Sweateringbottomsheet(
      state: Sweateringstatus.values[map['state']],
      sport: (map['sport'] as List<dynamic>).map((id) => sportsList.firstWhere((s) => s.id == id)).toList(),
      startedTime: map['startedTime'] != null ? DateTime.parse(map['startedTime']) : null,
      endedTime: map['endedTime'] != null ? DateTime.parse(map['endedTime']) : null,
    );
  }
}


