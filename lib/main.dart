import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // ← flutterfire configure로 생성된 파일
import 'app.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ★ 웹 포함 전 플랫폼 공통: options 반드시 지정
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance.activate(
    providerAndroid: const AndroidDebugProvider(),
    providerApple: const AppleDebugProvider(),
  );
  runApp(const ProviderScope(child: MyApp()));
}
