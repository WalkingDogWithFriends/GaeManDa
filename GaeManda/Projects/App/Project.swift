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
			resources: ["Resources/**"],
			entitlements: .relativeToRoot("Projects/App/Entitlements/Dev-GaeManda.entitlements"),
			dependencies: [
				.Project.PresentationLayer.SettingsImpl,
				.Project.PresentationLayer.ChattingImpl,
				.Project.PresentationLayer.SignInImpl,
				.Project.PresentationLayer.SignUpImpl,
				.Project.PresentationLayer.DogsOnAroundImpl,
				.Project.PresentationLayer.OnBoardingImpl,
				.Project.PresentationLayer.GMDProfileImpl,
				.Project.CoreLayer.GMDUtils,
				.Project.DomainLayer.UseCaseImpl,
				.Project.DataLayer.RepositoryImpl
			],
			settings: .settings(
				base: [
					"ASSETCATALOG_COMPILER_APPICON_NAME": "DevAppIcon"
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
			resources: ["Resources/**"],
			entitlements: .relativeToRoot("Projects/App/Entitlements/Prod-GaeManda.entitlements"),
			dependencies: [
				.Project.PresentationLayer.SettingsImpl,
				.Project.PresentationLayer.ChattingImpl,
				.Project.PresentationLayer.SignInImpl,
				.Project.PresentationLayer.SignUpImpl,
				.Project.PresentationLayer.DogsOnAroundImpl,
				.Project.PresentationLayer.OnBoardingImpl,
				.Project.PresentationLayer.GMDProfileImpl,
				.Project.CoreLayer.GMDUtils,
				.Project.DomainLayer.UseCaseImpl,
				.Project.DataLayer.RepositoryImpl
			],
			settings: .settings(
				base: [
					"ASSETCATALOG_COMPILER_APPICON_NAME": "ProdAppIcon"
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
