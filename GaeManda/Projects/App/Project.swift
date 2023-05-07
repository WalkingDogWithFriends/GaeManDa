import ProjectDescriptionHelpers
import ProjectDescription

let project = Project.createProject(
    name: "GaeManda",
    targets: [
        .createTarget(
            name: "Dev-App",
            product: .app,
            infoPlist: .file(path: .relativeToRoot("Projects/App/Info.plist")),
            resources: ["Resources/**"],
            dependencies: [
                .Project.PresentationLayer.SettingsImp,
                .Project.PresentationLayer.ChattingImp,
                .Project.PresentationLayer.SignInImp,
                .Project.PresentationLayer.SignUpImp,
                .Project.PresentationLayer.DogsOnAroundImp,
                .Project.DomainLayer.UseCaseImp
            ]
        )
    ]
)
