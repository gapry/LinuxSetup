if test -d "$HOME/Android/android-studio"
  fish_add_path "$HOME/Android/android-studio/bin"
end

if test -d "$HOME/Android/Sdk"
  set -gx ANDROID_SDK_ROOT "$HOME/Android/Sdk"
  set -gx ANDROID_HOME "$ANDROID_SDK_ROOT" # https://developer.android.com/tools
  
  fish_add_path "ANDROID_SDK_ROOT/emulator"
  fish_add_path "$ANDROID_SDK_ROOT/platform-tools"
end
