plugins {
    id("com.android.application")
    id("kotlin-android")
    // Flutter plugin must come after Android plugins
    id("dev.flutter.flutter-gradle-plugin")

    // Firebase plugin (wajib setelah flutter plugin)
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.smart_e_kantin_mobile"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.smart_e_kantin_mobile"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Firebase BOM (ini wajib, tapi aman buat semua service Firebase)
    implementation(platform("com.google.firebase:firebase-bom:33.1.2"))

    // Optional: jika sudah pakai auth atau firestore nanti tinggal hidupin ini ↓
    // implementation("com.google.firebase:firebase-auth")
    // implementation("com.google.firebase:firebase-firestore")
}