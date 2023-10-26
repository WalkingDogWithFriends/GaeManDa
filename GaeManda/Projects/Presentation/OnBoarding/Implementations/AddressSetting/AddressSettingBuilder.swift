//
//  AddressSettingBuilder.swift
//  OnBoardingImpl
//
//  Created by jung on 2023/06/25.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import OnBoarding

public protocol AddressSettingDependency: Dependency {    
    var detailAddressSettingBuildable: DetailAddressSettingBuildable { get }
}

final class AddressSettingComponent: Component<AddressSettingDependency> {
    fileprivate var detailAddressSettingBuildable: DetailAddressSettingBuildable {
        dependency.detailAddressSettingBuildable
    }
}

public final class AddressSettingBuilder:
	Builder<AddressSettingDependency>,
	AddressSettingBuildable {
	public override init(dependency: AddressSettingDependency) {
		super.init(dependency: dependency)
	}
	
	public func build(withListener listener: AddressSettingListener) -> ViewableRouting {
        let component = AddressSettingComponent(dependency: dependency)
		let viewController = AddressSettingViewController()
		let interactor = AddressSettingInteractor(presenter: viewController)
		interactor.listener = listener
		
		return AddressSettingRouter(
			interactor: interactor,
			viewController: viewController,
            detailAddressSettingBuildable: component.detailAddressSettingBuildable
		)
	}
}
