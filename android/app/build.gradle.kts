import java.io.FileInputStream
import java.util.Properties
import org.gradle.api.GradleException

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val releaseKeyPropertiesFile = rootProject.file("key.properties")
val releaseKeyProperties = Properties()
if (releaseKeyPropertiesFile.exists()) {
    FileInputStream(releaseKeyPropertiesFile).use(releaseKeyProperties::load)
}
val releaseStoreFile = releaseKeyProperties.getProperty("storeFile")
    ?.takeIf(String::isNotBlank)
    ?.let(::file)
val releaseSigningConfigured = listOf(
    "storePassword",
    "keyPassword",
    "keyAlias",
).all { !releaseKeyProperties.getProperty(it).isNullOrBlank() } &&
    releaseStoreFile?.isFile == true
val allowDebugReleaseSigning =
    providers.environmentVariable("ALLOW_DEBUG_SIGNING_FOR_RELEASE")
        .orNull == "true"

if (releaseKeyPropertiesFile.exists() && !releaseSigningConfigured) {
    throw GradleException(
        "android/key.properties is incomplete or its storeFile does not exist.",
    )
}

android {
    namespace = "com.yks.yks_study_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.yks.yks_study_app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    if (releaseSigningConfigured) {
        signingConfigs {
            create("release") {
                keyAlias = releaseKeyProperties.getProperty("keyAlias")
                keyPassword = releaseKeyProperties.getProperty("keyPassword")
                storeFile = releaseStoreFile
                storePassword = releaseKeyProperties.getProperty("storePassword")
            }
        }
    }

    buildTypes {
        getByName("release") {
            signingConfig = when {
                releaseSigningConfigured -> signingConfigs.getByName("release")
                allowDebugReleaseSigning -> signingConfigs.getByName("debug")
                else -> null
            }
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.2")
}

tasks.configureEach {
    if (
        name == "assembleRelease" ||
        name == "bundleRelease" ||
        name == "packageRelease" ||
        name == "packageReleaseBundle" ||
        name == "signReleaseBundle"
    ) {
        doFirst {
            if (!releaseSigningConfigured && !allowDebugReleaseSigning) {
                throw GradleException(
                    "Release signing is not configured. Create android/key.properties; " +
                        "for a local-only debug-signed build, set " +
                        "ALLOW_DEBUG_SIGNING_FOR_RELEASE=true explicitly.",
                )
            }
        }
    }
}
