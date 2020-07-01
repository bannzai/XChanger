iOSPlatform?=iOS Simulator
iOSDevice?=iPhone SE (2nd generation)
iOSSDK?=$(shell xcrun --sdk iphonesimulator --show-sdk-path)

.PHONY: install
install:
	swift package generate-xcodeproj

.PHONY: iOS
iOS: schema
	# See also: https://github.com/apple/swift/blob/master/utils/build-script-impl#L504
	swift build -Xswiftc "-sdk" -Xswiftc $(iOSSDK) -Xswiftc "-target" -Xswiftc "x86_64-apple-ios13.0-simulator"
	xcodebuild -workspace XChangerExample/iOS/XChangerExample.xcworkspace -scheme XChangerExample -destination 'platform=$(iOSPlatform),name=$(iOSDevice)'
	open XChangerExample/iOS/XChangerExample.xcworkspace

.PHONY: macOS
macOS: schema
	swift build 
	xcodebuild -workspace XChangerExample/macOS/XChangerExample.xcworkspace -scheme XChangerExample 
	open XChangerExample/macOS/XChangerExample.xcworkspace

.PHONY: carthage-project
carthage-project: install schema
	rm -rf XChanger-Carthage.xcodeproj
	cp -r XChanger.xcodeproj XChanger-Carthage.xcodeproj
 
.PHONY: test
test: schema sourcery
	xcodebuild test -project XChanger.xcodeproj -scheme XChanger -configuration Debug -sdk $(iOSSDK) -destination "platform=$(iOSPlatform),name=$(iOSDevice)" 

.PHONY: schema
schema: install
	mv XChanger.xcodeproj/xcshareddata/xcschemes/XChanger-Package.xcscheme XChanger.xcodeproj/xcshareddata/xcschemes/XChanger.xcscheme
