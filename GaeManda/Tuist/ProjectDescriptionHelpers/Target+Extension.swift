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
			bundleId: "com.gaemanda.\(name)Impl",
			deploymentTarget: .iOS(targetVersion: "15.0", devices: [.iphone]),
			infoPlist: nil,
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
			bundleId: "com.gaemanda.\(name)",
			deploymentTarget: .iOS(targetVersion: "15.0", devices: [.iphone]),
			infoPlist: nil,
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
			bundleId: "com.gaemanda.\(name)Tests",
			deploymentTarget: .iOS(targetVersion: "15.0", devices: [.iphone]),
			infoPlist: nil,
			sources: ["Tests/**"],
			dependencies: [
				.target(name: name + "Imp")
			]
		)
	}
}

public extension Target{
	static func createTarget(
		name: String,
		platform: Platform = .iOS,
		product: Product,
		bundleId: String? = nil,
		deploymentTarget: DeploymentTarget = .iOS(targetVersion: "15.0", devices: [.iphone]),
		infoPlist: InfoPlist = .default,
		sources: SourceFilesList = ["Sources/**"],
		resources: ResourceFileElements? = nil,
		dependencies: [TargetDependency] = [],
		settings: Settings? = nil
	) -> Target {
		var defaultBundleId = "com.gaemanda.\(name)"
		if let bingingBundleId = bundleId {
			defaultBundleId = bingingBundleId
		}
		return .init(
			name: name,
			platform: platform,
			product: product,
			bundleId: defaultBundleId,
			deploymentTarget: deploymentTarget,
			infoPlist: infoPlist,
			sources: sources,
			resources: resources,
			dependencies: dependencies,
			settings: settings
		)
	}
}
