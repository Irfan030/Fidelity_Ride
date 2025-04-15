plugins {
    id("com.android.application")
    id("kotlin-android")
     id("dev.flutter.flutter-gradle-plugin")

}

android {
    namespace = "com.example.fidelityride"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.fidelityride"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        // Add this line
        multiDexEnabled = true

        // Add these manifest placeholders
        manifestPlaceholders += mapOf(
            "googleMapsKey" to "AIzaSyDEQuMizKGG3iBx96RZWckPjQso8lFQ6V4" // Replace with your actual key
        )
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")

            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }

    // Add this if you're using custom build directories
    buildFeatures {
        buildConfig = true
    }
}

dependencies {
    // Add these dependencies
    implementation("com.google.android.gms:play-services-maps:19.1.0")
    implementation("com.google.android.gms:play-services-location:21.3.0")
    implementation("androidx.multidex:multidex:2.0.1")
}

flutter {
    source = "../.."
}
