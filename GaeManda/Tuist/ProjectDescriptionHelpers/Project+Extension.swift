import ProjectDescription

public extension Project {
    
    static func createProject(
        name: String,
        packages: [Package] = [],
        targets: [Target] = []
    ) -> Project {
        return Project(
            name: name,
            organizationName: "com.gmd",
            packages: packages,
            targets: targets
        )
    }
    
    static func createPresentationProject(
        name: String,
        packages: [Package] = [],
        implementationDependencies: [TargetDependency],
        interfaceDependencies: [TargetDependency]
    ) -> Project {
        
        let implementationTarget = Target.createImplementationTarget(name: name, dependencies: implementationDependencies)
        
        let interfaceTarget = Target.createIntefaceTarget(name: name, dependencies: interfaceDependencies)
        
        let testTarget = Target.createTestTarget(name: name)
        
        return Project(
            name: name,
            organizationName: "com.gmd",
            packages: packages,
            targets: [implementationTarget, interfaceTarget, testTarget]
        )
        
    }
    
}
