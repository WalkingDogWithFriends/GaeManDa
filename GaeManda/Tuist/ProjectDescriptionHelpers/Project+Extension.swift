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
			organizationName: "com.gmd",
			options: .options(automaticSchemesOptions: .disabled),
			packages: packages,
			targets: targets,
			additionalFiles: additionalFiles
		)
	}
}
