all : clean test-OSX

docs : playground html

test: test-iOS test-macOS test-tvOS

test-iOS:
	set -o pipefail && \
		xcodebuild \
		-project Just.xcodeproj \
		-scheme Just \
		-destination "name=iPhone 6s" \
		test \
		| xcpretty -ct

test-macOS:
	set -o pipefail && \
		xcodebuild \
		-project Just.xcodeproj \
		-scheme Just \
		test \
		| xcpretty -ct

test-tvOS:
	set -o pipefail && \
		xcodebuild \
		-project Just.xcodeproj \
		-scheme Just \
		-destination "name=Apple TV 1080p" \
		test \
		| xcpretty -ct

test-integration:
	cd Example && make -f Makefile

test-integration-cocoapods: \
	test-integration-cocoapods-iOS \
	test-integration-cocoapods-macOS \
	test-integration-cocoapods-watchOS \
	test-integration-cocoapods-tvOS

test-integration-cocoapods-iOS:
	cd Example/Cocoapods && \
	pod install && \
	set -o pipefail && \
		xcodebuild \
		-workspace Example.xcworkspace \
		-scheme Example-iOS \
		-destination "name=iPhone 6s" \
		| xcpretty -ct

test-integration-cocoapods-macOS:
	cd Example/Cocoapods && \
	pod install && \
	set -o pipefail && \
		xcodebuild \
		-workspace Example.xcworkspace \
		-scheme Example-macOS \
		| xcpretty -ct

test-integration-cocoapods-watchOS:
	cd Example/Cocoapods && \
	pod install && \
	set -o pipefail && \
		xcodebuild \
		-workspace Example.xcworkspace \
		-scheme Example-watchOS \
		-destination "name=iPhone 6s" \
		| xcpretty -ct

test-integration-cocoapods-tvOS:
	cd Example/Cocoapods && \
	pod install && \
	set -o pipefail && \
		xcodebuild \
		-workspace Example.xcworkspace \
		-scheme Example-tvOS \
		-destination "name=Apple TV 1080p" \
		| xcpretty -ct

test-integration-carthage: \
	test-integration-carthage-iOS \
	test-integration-carthage-macOS \
	test-integration-carthage-watchOS \
	test-integration-carthage-tvOS

test-integration-carthage-iOS:
	cd Example/Carthage && \
	carthage update --platform iOS && \
	set -o pipefail && \
		xcodebuild \
		-project Example.xcodeproj \
		-scheme Example-iOS \
		-destination "name=iPhone 6s" \
		| xcpretty -ct

test-integration-carthage-macOS:
	cd Example/carthage && \
	carthage update --platform macOS && \
	set -o pipefail && \
		xcodebuild \
		-project Example.xcodeproj \
		-scheme Example-macOS \
		| xcpretty -ct

test-integration-carthage-watchOS:
	cd Example/carthage && \
	carthage update --platform watchOS && \
	set -o pipefail && \
		xcodebuild \
		-project Example.xcodeproj \
		-scheme Example-watchOS \
		-destination "name=iPhone 6s" \
		| xcpretty -ct

test-integration-carthage-tvOS:
	cd Example/carthage && \
	carthage update --platform tvOS && \
	set -o pipefail && \
		xcodebuild \
		-project Example.xcodeproj \
		-scheme Example-tvOS \
		-destination "name=Apple TV 1080p" \
		| xcpretty -ct

test-integration-spm:
	cd Example/SPM && swift build

playground :
	@mkdir -p Docs/QuickStart.playground/Sources
	@cp Just/Just.swift Docs/QuickStart.playground/Sources/Just.swift
	cd ./Docs && zip -r -X QuickStart.zip QuickStart.playground/*

html :
	@docco -L Docs/docco.json -l linear -o Docs/html Docs/QuickStart.playground/Contents.swift
	mv Docs/html/Contents.html Docs/html/QuickStart.html

clean :
	@xcodebuild clean
	@rm -rf build
