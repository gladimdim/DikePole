flutter build web
cp -r build/web/assets ../../locadeserta/sloboda/
cp ./build/web/*.* ../../locadeserta/sloboda
flutter build apk
flutter build macos
