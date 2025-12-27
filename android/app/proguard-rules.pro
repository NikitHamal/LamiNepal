# Flutter specific ProGuard rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

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
