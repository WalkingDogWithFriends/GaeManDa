import ProjectDescription

public extension Project {
	static func createProject(
		name: String,
		packages: [Package] = [],
		targets: [Target] = [],
		additionalFiles: [FileElement] = []
	) -> Project {
		return Project(
			name: name,
			organizationName: "com.gaemanda",
			options: .options(automaticSchemesOptions: .disabled),
			packages: packages,
			targets: targets,
			additionalFiles: additionalFiles
		)
	}
	static func createPresentationProject(
		name: String,
		packages: [Package] = [],
		implementationDependencies: [TargetDependency],
		interfaceDependencies: [TargetDependency]
	) -> Project {
		let implementationTarget = Target.createImplementationTarget(
			name: name,
			dependencies: implementationDependencies
		)
		let interfaceTarget = Target.createIntefaceTarget(
			name: name,
			dependencies: interfaceDependencies
		)
		let testTarget = Target.createTestTarget(name: name)
		
		return Project(
			name: name,
			organizationName: "com.gaemanda",
			packages: packages,
			targets: [implementationTarget, interfaceTarget, testTarget]
		)
	}
}
