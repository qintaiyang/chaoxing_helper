import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
} else {
    println("key.properties not found. Please create it in the android directory.")
}

val localPropertiesFile = rootProject.file("local.properties")
val localProperties = Properties()
if (localPropertiesFile.exists()) {
    localProperties.load(FileInputStream(localPropertiesFile))
}

android {
    namespace = "com.chaoxinghelper"
    compileSdk = 36
    ndkVersion = "30.0.14904198"

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.chaoxinghelper"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        val baiduMapKey = localProperties.getProperty("BAIDU_MAP_API_KEY", "")
        manifestPlaceholders["BAIDU_MAP_API_KEY"] = baiduMapKey

        ndk {
            abiFilters.addAll(listOf("arm64-v8a", "armeabi-v7a"))
        }
    }

    signingConfigs {
        create("release") {
            if (keystoreProperties.containsKey("keyAlias")) {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
            }
        }
    }


    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            // signingConfig = signingConfigs.getByName("debug")
            
            // 启用代码混淆
            isMinifyEnabled = true
            isShrinkResources = true

            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            
            // 禁用 lint 检查以加快构建速度并避免文件锁定问题
            lint {
                checkDependencies = false
                abortOnError = false
            }
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
    implementation("com.baidu.lbsyun:BaiduMapSDK_Map:7.6.7")
    // flutter_bmflocation 插件已包含 BaiduMapSDK_Location_All
    implementation("com.baidu.lbsyun:BaiduMapSDK_Util:7.6.7")
}
