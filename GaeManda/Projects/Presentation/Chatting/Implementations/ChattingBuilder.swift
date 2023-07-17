//
//  ChattingBuilder.swift
//  ChattingImpl
//
//  Created by jung on 2023/07/17.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import Chatting

public protocol ChattingDependency: Dependency { }

final class ChattingComponent: Component<ChattingDependency> { }

public final class ChattingBuilder:
	Builder<ChattingDependency>,
	ChattingBuildable {
	public override init(dependency: ChattingDependency) {
		super.init(dependency: dependency)
	}
	
	public func build(withListener listener: ChattingListener) -> ViewableRouting {
		let component = ChattingComponent(dependency: dependency)
		let viewController = ChattingViewController()
		let interactor = ChattingInteractor(presenter: viewController)
		interactor.listener = listener
		return ChattingRouter(
			interactor: interactor,
			viewController: viewController
		)
	}
}
