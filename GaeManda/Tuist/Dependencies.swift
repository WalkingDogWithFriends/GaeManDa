import ProjectDescription

let dependencies = Dependencies(
	swiftPackageManager: [
		.remote(
			url: "https://github.com/uber/RIBs", requirement: .exact("0.14.0")
		),
		.remote(
			url: "https://github.com/ReactiveX/RxSwift.git", requirement: .exact("6.6.0")
		),
		.remote(
			url: "https://github.com/RxSwiftCommunity/RxGesture.git", requirement: .exact("4.0.1")
		),
		.remote(
			url: "https://github.com/SnapKit/SnapKit.git", requirement: .exact("5.6.0")
		),
		.remote(
			url: "https://github.com/WalkingDogWithFriends/NMapsMapSPM.git", requirement: .branch("main")
		)
	],
	platforms: [.iOS]
)
