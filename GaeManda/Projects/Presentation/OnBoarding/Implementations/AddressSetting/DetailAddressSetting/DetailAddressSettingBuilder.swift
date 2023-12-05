//
//  DetailAddressSettingBuilder.swift
//  OnBoarding
//
//  Created by jung on 2023/07/08.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import GMDUtils
import OnBoarding
import UseCase

public protocol DetailAddressSettingDependency: Dependency {
	var onBoardingUseCase: OnBoardingUseCase { get }
}

final class DetailAddressSettingComponent: 
	Component<DetailAddressSettingDependency>,
	DetailAddressSettingInteractorDependency {
	var onBoardingUseCase: OnBoardingUseCase { dependency.onBoardingUseCase }
}

public final class DetailAddressSettingBuilder:
	Builder<DetailAddressSettingDependency>,
	DetailAddressSettingBuildable {
	public override init(dependency: DetailAddressSettingDependency) {
		super.init(dependency: dependency)
	}
	
	public func build(withListener listener: DetailAddressSettingListener) -> ViewableRouting {
		let component = DetailAddressSettingComponent(dependency: dependency)
		let viewController = DetailAddressSettingViewController()
		let interactor = DetailAddressSettingInteractor(
			presenter: viewController,
			dependency: component
		)
		interactor.listener = listener
		return DetailAddressSettingRouter(
			interactor: interactor,
			viewController: viewController
		)
	}
}
