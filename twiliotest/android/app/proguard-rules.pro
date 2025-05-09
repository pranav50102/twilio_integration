# Flutter & Dart
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Prevent Flutter/Dart reflection issues
-keep class com.example.** { *; }  # Adjust to your package name

# Twilio Conversations
-keep class com.twilio.conversations.** { *; }
-keep class com.twilio.** { *; }
-dontwarn com.twilio.**

# JSON (Gson, etc.)
-keepattributes Signature
-keepattributes *Annotation*
-keep class com.google.gson.** { *; }
-dontwarn com.google.gson.**

# Required for Kotlin
-keep class kotlin.Metadata { *; }
-dontwarn kotlin.**

# Prevent issues with reflective usage (common with plugins)
-keepattributes InnerClasses
-keepattributes EnclosingMethod
-keep class **.R$* { *; }

-keep class tvi.webrtc.** { *; }
-keep class com.twilio.video.** { *; }
-keep class com.twilio.common.** { *; }
-keepattributes InnerClasses
# Optional: Log more if needed
# -dontobfuscate
# -verbose
