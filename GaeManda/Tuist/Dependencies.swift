import ProjectDescription

let dependencies = Dependencies(
  swiftPackageManager: [
    .remote(
      url: "https://github.com/uber/RIBs", requirement: .exact("0.14.0")
      
    )
  ],
  platforms: [.iOS]
)
