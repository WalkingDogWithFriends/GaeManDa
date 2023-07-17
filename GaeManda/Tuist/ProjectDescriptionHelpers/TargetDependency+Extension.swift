import ProjectDescription

public extension TargetDependency {
	struct Project {}
	struct SPM {}
}

public extension TargetDependency.Project {
	struct PresentationLayer {}
	struct CoreLayer {}
	struct DomainLayer {}
	struct DataLayer {}
	
	static let DesignKit = TargetDependency.project(
		target: "DesignKit",
		path: .relativeToRoot("Projects/DesignKit")
	)
}

//MARK: - Presentation Dependency
public extension TargetDependency.Project.PresentationLayer {
	static let Presentation = TargetDependency.project(
		target: "Presentation",
		path: .relativeToRoot("Projects/Presentation")
	)
	static let DogsOnAround = TargetDependency.project(
		target: "DogsOnAround",
		path: .relativeToRoot("Projects/Presentation/DogsOnAround")
	)
	static let Chatting = TargetDependency.project(
		target: "Chatting",
		path: .relativeToRoot("Projects/Presentation/Chatting")
	)
	static let Settings = TargetDependency.project(
		target: "Settings",
		path: .relativeToRoot("Projects/Presentation/Settings")
	)
	static let SignUp = TargetDependency.project(
		target: "SignUp",
		path: .relativeToRoot("Projects/Presentation/SignUp")
	)
	static let SignIn = TargetDependency.project(
		target: "SignIn",
		path: .relativeToRoot("Projects/Presentation/SignIn")
	)
	static let OnBoarding = TargetDependency.project(
		target: "OnBoarding",
		path: .relativeToRoot("Projects/Presentation/OnBoarding")
	)
	static let GMDProfile = TargetDependency.project(
		target: "GMDProfile",
		path: .relativeToRoot("Projects/Presentation/GMDProfile")
	)
	static let DogsOnAroundImpl = TargetDependency.project(
		target: "DogsOnAroundImpl",
		path: .relativeToRoot("Projects/Presentation/DogsOnAround")
	)
	static let ChattingImpl = TargetDependency.project(
		target: "ChattingImpl",
		path: .relativeToRoot("Projects/Presentation/Chatting")
	)
	static let SettingsImpl = TargetDependency.project(
		target: "SettingsImpl",
		path: .relativeToRoot("Projects/Presentation/Settings")
	)
	static let SignUpImpl = TargetDependency.project(
		target: "SignUpImpl",
		path: .relativeToRoot("Projects/Presentation/SignUp")
	)
	static let SignInImpl = TargetDependency.project(
		target: "SignInImpl",
		path: .relativeToRoot("Projects/Presentation/SignIn")
	)
	static let OnBoardingImpl = TargetDependency.project(
		target: "OnBoardingImpl",
		path: .relativeToRoot("Projects/Presentation/OnBoarding")
	)
	static let GMDProfileImpl = TargetDependency.project(
		target: "GMDProfileImpl",
		path: .relativeToRoot("Projects/Presentation/GMDProfile")
	)
}

//MARK: - Core Dependency
public extension TargetDependency.Project.CoreLayer {
	static let GMDExtensions = TargetDependency.project(
		target: "GMDExtensions",
		path: .relativeToRoot("Projects/Core")
	)
	static let GMDUtils = TargetDependency.project(
		target: "GMDUtils",
		path: .relativeToRoot("Projects/Core")
	)
}

//MARK: - Domain Dependency
public extension TargetDependency.Project.DomainLayer {
	static let Entity = TargetDependency.project(
		target: "Entity",
		path: .relativeToRoot("Projects/Domain")
	)
	static let UseCase = TargetDependency.project(
		target: "UseCase",
		path: .relativeToRoot("Projects/Domain")
	)
	static let UseCaseImpl = TargetDependency.project(
		target: "UseCaseImpl",
		path: .relativeToRoot("Projects/Domain")
	)
	static let Repository = TargetDependency.project(
		target: "Repository",
		path: .relativeToRoot("Projects/Domain")
	)
}

//MARK: - Data Dependency
public extension TargetDependency.Project.DataLayer {
	static let DTO = TargetDependency.project(
		target: "DTO",
		path: .relativeToRoot("Projects/Data")
	)
	static let RepositoryImpl = TargetDependency.project(
		target: "RepositoryImpl",
		path: .relativeToRoot("Projects/Data")
	)
	static let GMDNetwork = TargetDependency.project(
		target: "GMDNetwork",
		path: .relativeToRoot("Projects/Data")
	)
}

//MARK: - SPM Dependency
public extension TargetDependency.SPM {
	static let RIBs = TargetDependency.external(name: "RIBs")
	static let RxCocoa = TargetDependency.external(name: "RxCocoa")
}
