#! /bin/bash

echo "Clean..."
rm -rf build
# packflutter下构建aar的产物
rm -rf android/packflutter/flutter/
flutter clean

echo "Get packages..."
flutter packages get

if [ "$1" != "dev" ]; then
echo "Build release AOT"
# 生产模式产物
   flutter build aot --release --output-dir=build/flutteroutput
fi

echo "Build asset Bundle"
flutter build bundle --asset-dir=build/flutteroutput/flutter_assets

# 拷贝flutter.jar
echo 'Copy flutter jar'
if [ "$1" == "dev" ]; then
    mkdir -p android/packflutter/flutter/engine/android-arm-release && cp $FLUTTER_HOME/bin/cache/artifacts/engine/android-arm/flutter.jar "$_"
else
    mkdir -p android/packflutter/flutter/engine/android-arm-release && cp $FLUTTER_HOME/bin/cache/artifacts/engine/android-arm-release/flutter.jar "$_"
fi
# 拷贝asset
echo 'Copy flutter asset'
mkdir -p android/packflutter/flutter/assets/release && cp -r build/flutteroutput/* "$_"
mkdir -p android/packflutter/flutter/assets/release/flutter_assets && cp -r build/flutteroutput/flutter_assets/* "$_"

echo 'Build flutter to aar'
cd android
./gradlew :app:clean :packflutter:build

# aar路径
output=$(pwd)/packflutter/outputs/aar
echo 'output: '$output
