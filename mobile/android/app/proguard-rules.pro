# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.** { *; }
-dontwarn com.github.dart_lang.jni.**
-keep class com.github.dart_lang.jni.** { *; }

# Pigeon and SharedPreferences
-keep class dev.flutter.pigeon.** { *; }
-keep class dev.flutter.pigeon.shared_preferences_android.** { *; }
-dontwarn dev.flutter.pigeon.**
-dontwarn dev.flutter.pigeon.shared_preferences_android.**
-keep class io.flutter.plugins.sharedpreferences.** { *; }
-dontwarn io.flutter.plugins.sharedpreferences.**

# Razorpay SDK
-keepattributes *Annotation*
-dontwarn com.razorpay.**
-keep class com.razorpay.** { *; }
-optimizations !method/inlining/
-keepclasseswithmembers class * {
  public void onPaymentCheck(*);
  public void onPaymentSuccess(*);
  public void onPaymentError(*);
}
