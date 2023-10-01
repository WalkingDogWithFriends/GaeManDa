//
//  GMDProfileBuilder.swift
//  GMDProfileImpl
//
//  Created by jung on 2023/07/17.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import GMDProfile
import UseCase

public protocol GMDProfileDependency: Dependency {
	var gmdProfileUseCase: GMDProfileUseCase { get }
	var userProfileEditBuildable: UserProfileEditBuildable { get }
	var dogProfileEditBuildable: DogProfileEditBuildable { get }
	var newDogProfileBuildable: NewDogProfileBuildable { get }
}

final class GMDProfileComponent:
	Component<GMDProfileDependency>,
	GMDProfileInteractorDependency {
	var gmdProfileUseCase: GMDProfileUseCase {
		dependency.gmdProfileUseCase
	}
	fileprivate var userProfileEditBuildable: UserProfileEditBuildable {
		dependency.userProfileEditBuildable
	}
	fileprivate var dogProfileEditBuildable: DogProfileEditBuildable {
		dependency.dogProfileEditBuildable
	}
	fileprivate var newDogProfileBuildable: NewDogProfileBuildable {
		dependency.newDogProfileBuildable
	}
}

public final class GMDProfileBuilder:
	Builder<GMDProfileDependency>,
	GMDProfileBuildable {
	public override init(dependency: GMDProfileDependency) {
		super.init(dependency: dependency)
	}
	
	public func build(withListener listener: GMDProfileListener) -> ViewableRouting {
		let component = GMDProfileComponent(dependency: dependency)
		let viewController = GMDProfileViewController()
		let interactor = GMDProfileInteractor(
			presenter: viewController,
			dependency: component
		)
				
		interactor.listener = listener
		return GMDProfileRouter(
			interactor: interactor,
			viewController: viewController,
			userProfileEditBuildable: component.userProfileEditBuildable,
			dogProfileEditBuildable: component.dogProfileEditBuildable,
			newDogProfileBuildable: component.newDogProfileBuildable
		)
	}
}
