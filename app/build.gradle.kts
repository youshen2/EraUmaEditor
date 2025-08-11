plugins {
    alias(libs.plugins.android.application)
}

android {
    namespace = "moye.erauma.editor"
    compileSdk = 35

    defaultConfig {
        applicationId = "moye.erauma.editor"
        minSdk = 26
        targetSdk = 35
        versionCode = 1
        versionName = "1.0"

        resConfigs("zh")
    }

    buildTypes {
        release {
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }
    buildFeatures {
        viewBinding = true
    }
}

dependencies {
    implementation("androidx.appcompat:appcompat:1.6.1")
    implementation("com.google.android.material:material:1.11.0")
    implementation("androidx.constraintlayout:constraintlayout:2.1.4")
}