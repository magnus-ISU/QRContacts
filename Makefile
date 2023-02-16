all: preinstall_done

.PHONY: linux android ios

preinstall_done:
	flutter create .
	flutter pub get
	flutter pub global run rename --appname "QR Contacts"
	flutter pub global run rename --bundleId com.magnus.qrcontacts
	flutter pub run icons_launcher:create
	touch preinstall_done

linux: all
	flutter build $@ --release
web: all
	flutter build $@ --release
macos: all
	flutter build $@ --release
windows: all
	flutter build $@ --release
android: all
	flutter build apk --release 
ios: all
	flutter build ipa --release 
