import RIBs

final class AppComponent: Component<EmptyComponent>, AppRootDependency {
	init() {
		super.init(dependency: EmptyComponent())
	}
}
