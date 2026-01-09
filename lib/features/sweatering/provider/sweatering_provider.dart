import 'package:sweater/features/sweatering/model/sweateringstatus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SweateringstatusNotifier extends Notifier<Sweateringstatus> {
  final String uid;
  SweateringstatusNotifier(this.uid);
  @override
  // ignore: non_constant_identifier_names
  Sweateringstatus build() {
    return Sweateringstatus.none;
  }

  void complete() {
    state = Sweateringstatus.completed;
  }
  void reset() {
      state = Sweateringstatus.none;
    }
    
    void start() {
      state = Sweateringstatus.sweatering;
    }
  }


final sweateringstatusProvider = NotifierProvider.family<SweateringstatusNotifier, Sweateringstatus, String>(
  SweateringstatusNotifier.new,
);
