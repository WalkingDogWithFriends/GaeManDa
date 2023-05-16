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
			dependencies: [
				.Project.PresentationLayer.SettingsImpl,
				.Project.PresentationLayer.ChattingImpl,
				.Project.PresentationLayer.SignInImpl,
				.Project.PresentationLayer.SignUpImpl,
				.Project.PresentationLayer.DogsOnAroundImpl,
				.SPM.RIBs
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
			dependencies: [
				.Project.PresentationLayer.SettingsImpl,
				.Project.PresentationLayer.ChattingImpl,
				.Project.PresentationLayer.SignInImpl,
				.Project.PresentationLayer.SignUpImpl,
				.Project.PresentationLayer.DogsOnAroundImpl,
				.SPM.RIBs
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
