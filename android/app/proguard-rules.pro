# Flutter specific ProGuard rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.** { *; }

# Google Play Core library rules
# These rules handle the deferred components manager classes referenced by Flutter
-keep class com.google.android.play.core.** { *; }
-keep interface com.google.android.play.core.** { *; }

# Play Core Tasks API (required for Flutter's PlayStoreDeferredComponentManager)
-keep class com.google.android.play.core.tasks.** { *; }
-keep interface com.google.android.play.core.tasks.OnFailureListener { *; }
-keep interface com.google.android.play.core.tasks.OnSuccessListener { *; }
-keep class com.google.android.play.core.tasks.Task { *; }
-keep class com.google.android.play.core.tasks.Tasks { *; }

# Play Core SplitInstall API (for deferred component installation)
-keep class com.google.android.play.core.splitinstall.** { *; }
-keep interface com.google.android.play.core.splitinstall.** { *; }

# Dontwarn rules for Play Core classes that may not be present at runtime
# This prevents R8 from failing when these classes are referenced but not used
-dontwarn com.google.android.play.core.tasks.OnFailureListener
-dontwarn com.google.android.play.core.tasks.OnSuccessListener
-dontwarn com.google.android.play.core.tasks.Task
-dontwarn com.google.android.play.core.tasks.Tasks
-dontwarn com.google.android.play.core.splitinstall.**
-dontwarn com.google.android.play.core.splitcompat.**
-dontwarn com.google.android.play.core.common.**

# Keep Lami Nepal app classes
-keep class com.laminepal.app.** { *; }

# Keep Kotlin classes
-keep class kotlin.** { *; }
-keepclassmembers class kotlin.Metadata { *; }

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep annotations
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable
-keepattributes Signature
-keepattributes Exceptions

# Crash reporting
-keepattributes StackTraceElement

# URL handling
-keepclassmembers class * implements android.os.Parcelable {
    static ** CREATOR;
}
