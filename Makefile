.PHONY: gen build clean ipa

gen:
	xcodegen generate

build: gen
	xcodebuild -project PSRemote.xcodeproj \
		-scheme PSRemote \
		-configuration Debug \
		-sdk iphonesimulator \
		-derivedDataPath build \
		CODE_SIGNING_ALLOWED=NO \
		build

ipa: gen
	xcodebuild -project PSRemote.xcodeproj \
		-scheme PSRemote \
		-configuration Release \
		-sdk iphoneos \
		-derivedDataPath build \
		CODE_SIGNING_ALLOWED=NO \
		CODE_SIGNING_REQUIRED=NO \
		CODE_SIGN_IDENTITY="" \
		build
	rm -rf Payload PSRemote.ipa
	mkdir -p Payload
	cp -r build/Build/Products/Release-iphoneos/PSRemote.app Payload/
	zip -qr PSRemote.ipa Payload
	@echo "Gotowe: PSRemote.ipa"

clean:
	rm -rf build PSRemote.xcodeproj Payload PSRemote.ipa
