all: preinstall_done

preinstall_done:
	flutter create .
	flutter pub get
	flutter pub global run rename --appname "QR Contacts"
	flutter pub global run rename --bundleId com.magnus.qrcontacts
	flutter pub run icons_launcher:create
	touch preinstall_done

linux: all
	flutter build --release linux
android:
