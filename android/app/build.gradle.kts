plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.sweater"

    // 최신 SDK
    compileSdk = 35

    // defaultConfig는 단 한 번만!
    defaultConfig {
        applicationId = "com.example.sweater"
        minSdk = 23                  // Firebase 플러그인 요구치
        targetSdk = 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // 필요 시 주석 해제
        // multiDexEnabled = true
    }

    // Firebase 플러그인들이 요구하는 NDK 버전
    ndkVersion = "27.0.12077973"

    // Java/Kotlin 설정
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }
    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    buildTypes {
        release {
            // 데모 용으로 debug 서명키 사용 (배포 전 교체)
            signingConfig = signingConfigs.getByName("debug")
            // 필요 시 최적화 옵션 추가
            // isMinifyEnabled = true
            // proguardFiles(
            //     getDefaultProguardFile("proguard-android-optimize.txt"),
            //     "proguard-rules.pro"
            // )
        }
    }

    // (옵션) 패키징 충돌 나면 주석 해제해서 사용
    // packaging {
    //     resources {
    //         excludes += "/META-INF/{AL2.0,LGPL2.1}"
    //     }
    // }
}

// Flutter Gradle Plugin에서 제공하는 extension
flutter {
    source = "../.."
}