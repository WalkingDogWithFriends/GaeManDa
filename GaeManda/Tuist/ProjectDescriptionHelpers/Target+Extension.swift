import Foundation
import ProjectDescription

fileprivate let commonScripts: [TargetScript] = [
	.pre(
		script: """
	ROOT_DIR=\(ProcessInfo.processInfo.environment["TUIST_ROOT_DIR"] ?? "")
	
	${ROOT_DIR}/swiftlint --config ${ROOT_DIR}/.swiftlint.yml
	
	""",
		name: "SwiftLint",
		basedOnDependencyAnalysis: false
	)
]

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
			infoPlist: .default,
			sources: ["Implementations/**"],
			scripts: commonScripts,
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
			product: .staticLibrary,
			bundleId: "com.gaemanda.\(name)",
			deploymentTarget: .iOS(targetVersion: "15.0", devices: [.iphone]),
			infoPlist: .default,
			sources: ["Interfaces/**"],
			scripts: commonScripts,
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
			infoPlist: .default,
			sources: ["Tests/**"],
			scripts: commonScripts,
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
		bundleId: String? = nil,
		deploymentTarget: DeploymentTarget = .iOS(targetVersion: "15.0", devices: [.iphone]),
		infoPlist: InfoPlist = .default,
		sources: SourceFilesList = ["Sources/**"],
		resources: ResourceFileElements? = nil,
		scripts: [TargetScript] = [],
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
			scripts: commonScripts + scripts,
			dependencies: dependencies,
			settings: settings
		)
	}
}
