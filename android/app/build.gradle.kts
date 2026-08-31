plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val productionKeystorePath = System.getenv("YADNEGAR_KEYSTORE_PATH")
val productionStorePassword = System.getenv("YADNEGAR_STORE_PASSWORD")
val productionKeyAlias = System.getenv("YADNEGAR_KEY_ALIAS")
val productionKeyPassword = System.getenv("YADNEGAR_KEY_PASSWORD")
val productionSigningReady = listOf(
    productionKeystorePath,
    productionStorePassword,
    productionKeyAlias,
    productionKeyPassword,
).all { !it.isNullOrBlank() }

android {
    namespace = "com.mobinpda.lab.yadnegar"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.mobinpda.lab.yadnegar"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true
    }

    signingConfigs {
        if (productionSigningReady) {
            create("production") {
                storeFile = file(productionKeystorePath!!)
                storePassword = productionStorePassword
                keyAlias = productionKeyAlias
                keyPassword = productionKeyPassword
            }
        }
    }

    buildTypes {
        release {
            // Local/dev release-mode builds keep the existing debug-key fallback.
            // Production automation must provide every YADNEGAR_* signing variable;
            // the production release controller never accepts the fallback artifact.
            signingConfig = if (productionSigningReady) {
                signingConfigs.getByName("production")
            } else {
                signingConfigs.getByName("debug")
            }
        }
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}

flutter {
    source = "../.."
}
