//
//  DogProfileFirstDashboardInteractor.swift
//  CorePresentation
//
//  Created by jung on 12/16/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import RxRelay
import CorePresentation
import Entity

protocol DogProfileFirstDashboardRouting: ViewableRouting {
	func birthdayPickerAttach()
	func birthdayPickerDetach()
}

protocol DogProfileFirstDashboardPresentable: Presentable {
	var listener: DogProfileFirstDashboardPresentableListener? { get set }
	
	func updateDog(_ viewModel: DogProfileFirstDashboardViewModel)
	func updateNameTextFieldIsWarning()
	func updatebirthdayTextFieldIsWarning()
	func updateWeightTextFieldIsWarning()
	func updateBirthday(date: String)
}

final class DogProfileFirstDashboardInteractor:
	PresentableInteractor<DogProfileFirstDashboardPresentable>,
	DogProfileFirstDashboardInteractable {
	weak var router: DogProfileFirstDashboardRouting?
	weak var listener: DogProfileFirstDashboardListener?
	
	private let viewModel: DogProfileFirstDashboardViewModel?
	private let nameTextFieldIsWarning: BehaviorRelay<Void>
	private let birthdayTextFieldIsWarning: BehaviorRelay<Void>
	private let weightTextFieldIsWarning: BehaviorRelay<Void>
	
	init(
		presenter: DogProfileFirstDashboardPresentable,
		passingModel: DogProfileFirstPassingModel?,
		nameTextFieldIsWarning: BehaviorRelay<Void>,
		birthdayTextFieldIsWarning: BehaviorRelay<Void>,
		weightTextFieldIsWarning: BehaviorRelay<Void>
	) {
		if let passingModel = passingModel {
			self.viewModel = DogProfileFirstDashboardViewModel(passingModel)
		} else {
			self.viewModel = nil
		}

		self.nameTextFieldIsWarning = nameTextFieldIsWarning
		self.birthdayTextFieldIsWarning = birthdayTextFieldIsWarning
		self.weightTextFieldIsWarning = weightTextFieldIsWarning
		
		super.init(presenter: presenter)
		presenter.listener = self
	}
	
	override func didBecomeActive() {
		super.didBecomeActive()
	}
	
	override func willResignActive() {
		super.willResignActive()
	}
}

// MARK: - DogProfileFirstDashboardPresentableListener
extension DogProfileFirstDashboardInteractor: DogProfileFirstDashboardPresentableListener {
	func viewDidLoad() {
		if let viewModel = viewModel {
			presenter.updateDog(viewModel)
		}

		nameTextFieldIsWarning
			.skip(1)
			.bind(with: self) { owner, _ in
				owner.presenter.updateNameTextFieldIsWarning()
			}
			.disposeOnDeactivate(interactor: self)
		
		birthdayTextFieldIsWarning
			.skip(1)
			.bind(with: self) { owner, _ in
				owner.presenter.updatebirthdayTextFieldIsWarning()
			}
			.disposeOnDeactivate(interactor: self)
		
		weightTextFieldIsWarning
			.skip(1)
			.bind(with: self) { owner, _ in
				owner.presenter.updateWeightTextFieldIsWarning()
			}
			.disposeOnDeactivate(interactor: self)
	}
	
	func didTapCalenderButton() {
		router?.birthdayPickerAttach()
	}
	
	func didSelectedGender(_ gender: Gender) {
		listener?.didSelectedGender(gender)
	}
	
	func didEnteredDogName(_ name: String) {
		listener?.didEnteredDogName(name)
	}
	
	func didEnteredDogWeight(_ weight: Int) {
		listener?.didEnteredDogWeight(weight)
	}
}

// MARK: - BirthdayPickerListener
extension DogProfileFirstDashboardInteractor {
	func birthdayPickerDismiss() {
		router?.birthdayPickerDetach()
	}
	
	func birthdaySelected(date: String) {
		presenter.updateBirthday(date: date)
		router?.birthdayPickerDetach()
		listener?.didSelectedBirthday(date)
	}
}
