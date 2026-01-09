import '../features/sweatering/model/sweateringstatus.dart';

class UserSweatering {
  final String uid;
  final Sweateringstatus status;

  UserSweatering({
    required this.uid,
    required this.status,
  });
}