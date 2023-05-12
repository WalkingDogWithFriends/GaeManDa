import ProjectDescription

public extension Target {
	static func createImplementationTarget(
		name: String,
		dependencies: [TargetDependency] = []
	) -> Target {
		return .init(
			name: "\(name)Impl",
			platform: .iOS,
			product: .staticLibrary,
			bundleId: "com.gmd.app.\(name)Impl",
			deploymentTarget: .iOS(targetVersion: "15.0", devices: [.iphone]),
			infoPlist: .default,
			sources: ["Implementations/**"],
			dependencies: dependencies
		)
	}
	static func createIntefaceTarget(
		name: String,
		dependencies: [TargetDependency] = []
	) -> Target {
		return .init(
			name: name,
			platform: .iOS,
			product: .framework,
			bundleId: "com.gmd.app.\(name)",
			deploymentTarget: .iOS(targetVersion: "15.0", devices: [.iphone]),
			infoPlist: .default,
			sources: ["Interfaces/**"],
			dependencies: dependencies
		)
	}
	static func createTestTarget(
		name: String
	) -> Target {
		return .init(
			name: "\(name)Tests",
			platform: .iOS,
			product: .unitTests,
			bundleId: "com.gmd.app.\(name)Tests",
			deploymentTarget: .iOS(targetVersion: "15.0", devices: [.iphone]),
			infoPlist: .default,
			sources: ["Tests/**"],
			dependencies: [
				.target(name: name + "Impl")
			]
		)
	}
}

public extension Target{
	static func createTarget(
		name: String,
		platform: Platform = .iOS,
		product: Product,
		deploymentTarget: DeploymentTarget = .iOS(targetVersion: "15.0", devices: [.iphone]),
		infoPlist: InfoPlist = .default,
		sources: SourceFilesList = ["Sources/**"],
		resources: ResourceFileElements? = nil,
		dependencies: [TargetDependency] = [],
		settings: Settings? = nil
	) -> Target {
		return .init(
			name: name,
			platform: platform,
			product: product,
			bundleId: "com.gmd.app.\(name)",
			deploymentTarget: deploymentTarget,
			infoPlist: infoPlist,
			sources: sources,
			resources: resources,
			dependencies: dependencies,
			settings: settings
		)
	}
}
