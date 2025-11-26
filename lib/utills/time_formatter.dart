// lib/utils/time_formatter.dart
import 'package:intl/intl.dart';

/// Firestore Timestamp나 DateTime을 사람이 읽기 쉬운 문자열로 변환.
/// 예: 5분 전, 3시간 전, 2일 전, 2024.05.01
String formatTimeAgo(DateTime? time) {
  if (time == null) return '';

  final now = DateTime.now();
  final diff = now.difference(time);

  if (diff.inSeconds < 60) {
    return '방금 전';
  } else if (diff.inMinutes < 60) {
    return '${diff.inMinutes}분 전';
  } else if (diff.inHours < 24) {
    return '${diff.inHours}시간 전';
  } else if (diff.inDays < 7) {
    return '${diff.inDays}일 전';
  } else {
    return DateFormat('yyyy.MM.dd').format(time);
  }
}
