import 'package:google_maps_flutter/google_maps_flutter.dart';

class Runstate {
  final bool isTracking;
  final List<LatLng> path;
  final double distance;
  final double elevation;
  final double speed;
  final DateTime? startTime;
  final DateTime? endTime;

  Runstate({
    this.isTracking = false,
    this.path = const [],
    this.distance = 0.0,
    this.elevation = 0.0,
    this.speed = 0.0,
    this.startTime,
    this.endTime,
  });

  Runstate copyWith({
    bool? isTracking,
    List<LatLng>? path,
    double? distance,
    double? elevation,
    double? speed,
    DateTime? startTime,
    DateTime? endTime,
  }) {
    return Runstate(
      isTracking: isTracking ?? this.isTracking,
      path: path ?? this.path,
      distance: distance ?? this.distance,
      elevation: elevation ?? this.elevation,
      speed: speed ?? this.speed,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }
/// 총 경과 시간
Duration get elapsed {
  if (startTime == null) return Duration.zero;
  return (endTime ?? DateTime.now()).difference(startTime!);
}

///평균 속도(m/s)
double? get avgSpeedMs {
  final seconds = elapsed.inSeconds;
  if (seconds == 0 || distance == 0) return null;
  return distance / seconds;
}

/// 평균속도(km/h)
double? get avgSpeedKmh {
  final v = avgSpeedMs;
  if (v == null) return null;
  return v * 3.6;
}

///(초/1km)
double? get paceSecPerKm {
  final km = distance / 1000;
  if (km == 0) return null;
  return elapsed.inSeconds / km;
}

///평균 페이스 텍스트(예: 5'30''/km)

String? get paceText {
  final p = paceSecPerKm;
  if (p == null) return null;
  final totalSec = p.toInt();
  final m = totalSec ~/ 60;
  final s = totalSec % 60;
  return "$m'${s.toString().padLeft(2, '0')} \"/km";
}
}