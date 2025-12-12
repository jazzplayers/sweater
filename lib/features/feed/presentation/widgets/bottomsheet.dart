import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sweater/features/sweatering/presentation/sweatering_page.dart';
import 'package:sweater/models/sweateringstatus.dart';
import 'package:sweater/models/sport.dart';
import 'package:sweater/features/sweatering/widget/build_switch_tile.dart';
import 'package:sweater/features/sweatering/widget/wheelpicker.dart';


// 팔로워에게 공유
final shareFollowersProvider = StateProvider<bool>((ref) => false);
// 위치 공유
final shareLocationProvider = StateProvider<bool>((ref) => false);
// 운동 상태 공유
final shareStatusProvider = StateProvider<bool>((ref) => false);
// 
final sweateringStateProvider = StateProvider<Sweateringstatus>((ref) => Sweateringstatus.none);

class SweateringBottomSheet extends ConsumerWidget {
  const SweateringBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _shareFollowers = ref.watch(shareFollowersProvider);
    final _shareLocation = ref.watch(shareLocationProvider);
    final _shareStatus = ref.watch(shareStatusProvider);
    final _isFollowOn = _shareFollowers;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, -3),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---- 메뉴 목록 ----
          wheelPicker(
            ref: ref,
           sportsList: sportsList, 
           onSelected: (Sport sport) {
            print("선택된 운동 ${sport.name}");
           }),
           SizedBox(height: 8,),
          buildSwitchTile(
            title: "팔로워공유",
            value: _shareFollowers,
            enabled: true,
            onChanged: (val) {
            ref.read(shareFollowersProvider.notifier).state = val;
            if (!val) {
              // 팔로워 공유를 끄면 위치/상태 공유도 끔
              ref.read(shareLocationProvider.notifier).state = false;
              ref.read(shareStatusProvider.notifier).state = false;
            } else {
              // 팔로워 공유를 켜면 위치/상태 공유는 기본값(true)로 설정
              ref.read(shareLocationProvider.notifier).state = true;
              ref.read(shareStatusProvider.notifier).state = true;
            }
          }),
          buildSwitchTile(
            title: "위치 공유",
            value: _shareLocation,
            enabled: _isFollowOn,
            onChanged: (val) => ref.read(shareLocationProvider.notifier).state = val,
          ),
          buildSwitchTile(
            title: "상태 공유",
            value: _shareStatus,
            enabled: _isFollowOn,
            onChanged: (val) => ref.read(shareStatusProvider.notifier).state = val,
          ),

          const SizedBox(height: 24),

          // ---- 확인 버튼 ----
          SizedBox(
            width: double.infinity,
            child: CupertinoButton.filled(
              onPressed: () {
                final selectedSport = ref.read(selectedSportProvider);
                if (selectedSport == null) {
                  return;
                }
                ref.read(sweateringStateProvider.notifier).state = Sweateringstatus.sweatering;
                // TODO: 여기서 값들(_shareFollowers 등) 넘겨서 저장하거나 Firestore에 반영
                Navigator.of(context).pop(); // 바텀시트 닫기
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => SweateringPage(sport: selectedSport),
                ));
              },
              child: const Text("SWEATERING"),
            ),
          ),
        ],
      ),
    );
  }

}
