//
//  ChattingListBuilder.swift
//  ChattingImpl
//
//  Created by jung on 2023/08/16.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import Chatting

public protocol ChattingListDependency: Dependency {
	var chattingBuildable: ChattingBuildable { get }
}

final class ChattingListComponent: Component<ChattingListDependency> {
	var chattingBuildable: ChattingBuildable {
		return dependency.chattingBuildable
	}
}

public final class ChattingListBuilder:
	Builder<ChattingListDependency>,
	ChattingListBuildable {
	public override init(dependency: ChattingListDependency) {
		super.init(dependency: dependency)
	}
	
	public func build(withListener listener: ChattingListListener) -> ViewableRouting {
		let component = ChattingListComponent(dependency: dependency)
		let viewController = ChattingListViewController()
		let interactor = ChattingListInteractor(presenter: viewController)
		interactor.listener = listener
		return ChattingListRouter(
			interactor: interactor,
			viewController: viewController,
			chattingBuildable: component.chattingBuildable
		)
	}
}
