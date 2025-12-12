import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  @override
  ConsumerState<MapPage> createState() => MapPageState();
}

class MapPageState extends ConsumerState<MapPage> {
  @override
  Widget build(BuildContext context) {
    // 위치 스트림 구독
    final asyncLocation = ref.watch(positionStreamProvider);

    return asyncLocation.when(
      data: (myLatLng) {
        if (myLatLng == null) {
          return const Center(
            child: Text('위치 서비스를 켜거나 권한을 허용해주세요.'),
          );
        }

        return GoogleMap(
          initialCameraPosition: CameraPosition(
            target: myLatLng,
            zoom: 12,
          ),
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          polylines: {
            Polyline(
              polylineId: const PolylineId('current_path'),
              color: Colors.blue,
              width: 5,
              points: [
                myLatLng,
              ],
            ),
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('위치 에러: $e')),
    );
  }
}

/// 위치 스트림 Provider (현재 위치를 계속 받아옴)
final positionStreamProvider = StreamProvider<LatLng?>((ref) async* {
  bool serviceEnabled;
  LocationPermission permission;

  // 1) 위치 서비스 켜져 있는지 확인
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // 서비스 꺼져 있으면 null만 내보내고 끝
    yield null;
    return;
  }

  // 2) 권한 확인 및 요청
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // 유저가 거절
      yield null;
      return;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // 영구 거절
    yield null;
    return;
  }

  // 3) 여기까지 오면 권한 OK → 위치 스트림 발행
  const locationSettings = LocationSettings(
    accuracy: LocationAccuracy.best,
    distanceFilter: 5, // 5m 이동마다 콜백
  );

  // Position 스트림 → LatLng 스트림으로 변환
  yield* Geolocator.getPositionStream(
    locationSettings: locationSettings,
  ).map((position) {
    return LatLng(position.latitude, position.longitude);
  });
});
