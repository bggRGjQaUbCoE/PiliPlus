all:
	test -d ../../../native/artifacts/macos/Frameworks
	mkdir -p Frameworks
	cp -R ../../../native/artifacts/macos/Frameworks/*.xcframework Frameworks/
	mkdir -p Frameworks/.symlinks/mpv
	sh create_framework_symlinks.sh Frameworks/Mpv.xcframework Frameworks/.symlinks/mpv
