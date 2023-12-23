//
//  DogProfileFirstDashboardBuilder.swift
//  CorePresentation
//
//  Created by jung on 12/16/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import RxRelay
import CorePresentation

public protocol DogProfileFirstDashboardDependency: Dependency, BirthdayPickerDependency { }

final class DogProfileFirstDashboardComponent: Component<DogProfileFirstDashboardDependency> { }

public final class DogProfileFirstDashboardBuilder:
	Builder<DogProfileFirstDashboardDependency>,
	DogProfileFirstDashboardBuildable {
	public override init(dependency: DogProfileFirstDashboardDependency) {
		super.init(dependency: dependency)
	}
	
	public func build(
		withListener listener: DogProfileFirstDashboardListener,
		nameTextFieldIsWarning: BehaviorRelay<Void>,
		birthdayTextFieldIsWarning: BehaviorRelay<Void>,
		weightTextFieldIsWarning: BehaviorRelay<Void>,
		passingModel: DogProfileFirstPassingModel?
	) -> ViewableRouting {
		let component = DogProfileFirstDashboardComponent(dependency: dependency)
		let viewController = DogProfileFirstDashboardViewController()
		
		let interactor = DogProfileFirstDashboardInteractor(
			presenter: viewController,
			passingModel: passingModel,
			nameTextFieldIsWarning: nameTextFieldIsWarning,
			birthdayTextFieldIsWarning: birthdayTextFieldIsWarning,
			weightTextFieldIsWarning: weightTextFieldIsWarning
		)
		
		interactor.listener = listener
		
		let birthdayPickerBuildable = BirthdayPickerBuilder(dependency: dependency)

		return DogProfileFirstDashboardRouter(
			interactor: interactor,
			viewController: viewController,
			birthdayPickerBuildable: birthdayPickerBuildable
		)
	}
}
