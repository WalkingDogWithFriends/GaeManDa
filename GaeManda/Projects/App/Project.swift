import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.createProject(
	name: "GaeManda",
	targets: [
		.createTarget(
			name: "Dev-GaeManda",
			product: .app,
			bundleId: "com.gaemanda.dev",
			infoPlist: .file(path: .relativeToRoot("Projects/App/Info.plist")),
			resources: [.glob(pattern: "Resources/**", excluding: ["Resources/prod/**"])],
			entitlements: .relativeToRoot("Projects/App/Entitlements/Dev-GaeManda.entitlements"),
			dependencies: [
				.Project.PresentationLayer.CorePresentationImpl,
				.Project.PresentationLayer.ChattingImpl,
				.Project.PresentationLayer.SignInImpl,
				.Project.PresentationLayer.GMDMapImpl,
				.Project.PresentationLayer.OnBoardingImpl,
				.Project.PresentationLayer.GMDProfileImpl,
				.Project.CoreLayer.GMDUtils,
				.Project.DomainLayer.UseCaseImpl,
				.Project.DataLayer.RepositoryImpl,
				.SPM.KakaoSDKAuth,
				.SPM.FirebaseMessaging
			],
			settings: .settings(
				base: [
					"ASSETCATALOG_COMPILER_APPICON_NAME": "DevAppIcon",
					"OTHER_LDFLAGS": "-ObjC"
				],
				configurations: [
					.debug(name: .debug, xcconfig: "./xcconfigs/GaeManda.debug.xcconfig")
				]
			)
		),
		.createTarget(
			name: "Prod-GaeManda",
			product: .app,
			bundleId: "com.gaemanda",
			infoPlist: .file(path: .relativeToRoot("Projects/App/Info.plist")),
			resources: [.glob(pattern: "Resources/**", excluding: ["Resources/dev/**"])],
			entitlements: .relativeToRoot("Projects/App/Entitlements/Prod-GaeManda.entitlements"),
			dependencies: [
				.Project.PresentationLayer.CorePresentationImpl,
				.Project.PresentationLayer.ChattingImpl,
				.Project.PresentationLayer.SignInImpl,
				.Project.PresentationLayer.GMDMapImpl,
				.Project.PresentationLayer.OnBoardingImpl,
				.Project.PresentationLayer.GMDProfileImpl,
				.Project.CoreLayer.GMDUtils,
				.Project.DomainLayer.UseCase,
				.Project.DomainLayer.Repository,
				.Project.DomainLayer.UseCaseImpl,
				.Project.DataLayer.RepositoryImpl,
				.SPM.KakaoSDKAuth,
				.SPM.FirebaseMessaging
			],
			settings: .settings(
				base: [
					"ASSETCATALOG_COMPILER_APPICON_NAME": "ProdAppIcon",
					"OTHER_LDFLAGS": "-ObjC"
				],
				configurations: [
					.release(name: .release, xcconfig: "./xcconfigs/GaeManda.release.xcconfig")
				]
			)
		)
	],
	additionalFiles: [
		"./xcconfigs/GaeManda.shared.xcconfig"
	]
)
