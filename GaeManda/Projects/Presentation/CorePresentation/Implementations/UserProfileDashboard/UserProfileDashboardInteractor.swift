//
//  UserProfileDashboardInteractor.swift
//  CorePresentation
//
//  Created by jung on 12/14/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import RxCocoa
import RxSwift
import CorePresentation
import DesignKit
import Entity

protocol UserProfileDashboardRouting: ViewableRouting {
	func birthdayPickerAttach()
	func birthdayPickerDetach()
}

protocol UserProfileDashboardPresentable: Presentable {
	var listener: UserProfileDashboardPresentableListener? { get set }
	
	func updateNameTextMode(_ textFieldMode: NicknameTextFieldMode)
	func updatebirthdayTextFieldIsWarning(_ isWarning: Bool)
	func updateUser(_ viewModel: UserProfileDashboardViewModel)
	func updateBirthday(date: String)
}

final class UserProfileDashboardInteractor:
	PresentableInteractor<UserProfileDashboardPresentable>,
	UserProfileDashboardInteractable,
	UserProfileDashboardPresentableListener {
	weak var router: UserProfileDashboardRouting?
	weak var listener: UserProfileDashboardListener?
	
	private let viewModel: UserProfileDashboardViewModel?
	private let nicknameTextFieldMode: BehaviorRelay<NicknameTextFieldMode>
	private let birthdayTextFieldIsWarning: BehaviorRelay<Bool>
	
	init(
		presenter: UserProfileDashboardPresentable,
		passingModel: UserProfilePassingModel?,
		nicknameTextFieldMode: BehaviorRelay<NicknameTextFieldMode>,
		birthdayTextFieldIsWarning: BehaviorRelay<Bool>
	) {
		if let passingModel = passingModel {
			self.viewModel = UserProfileDashboardViewModel(passingModel)
		} else {
			self.viewModel = nil
		}

		self.nicknameTextFieldMode = nicknameTextFieldMode
		self.birthdayTextFieldIsWarning = birthdayTextFieldIsWarning
		
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

// MARK: - PresentableListener
extension UserProfileDashboardInteractor {
	func viewDidLoad() {
		if let viewModel = viewModel {
			presenter.updateUser(viewModel)
		}
		
		nicknameTextFieldMode
			.bind(with: self) { owner, mode in
				owner.presenter.updateNameTextMode(mode)
			}
			.disposeOnDeactivate(interactor: self)
		
		birthdayTextFieldIsWarning
			.bind(with: self) { owner, isWarning in
				owner.presenter.updatebirthdayTextFieldIsWarning(isWarning)
			}
			.disposeOnDeactivate(interactor: self)
	}
	
	func calenderButtonDidTap() {
		router?.birthdayPickerAttach()
	}
	
	func didSelectedGender(_ gender: Gender) {
		listener?.didSelectedGender(gender)
	}
	
	func didEnteredUserName(_ name: String) {
		listener?.didEnteredUserName(name)
	}
}

// MARK: - BirthdayPickerListener
extension UserProfileDashboardInteractor {
	func birthdayPickerDismiss() {
		router?.birthdayPickerDetach()
	}
	
	func birthdaySelected(date: String) {
		presenter.updateBirthday(date: date)
		router?.birthdayPickerDetach()
		listener?.didSelectedBirthday(date)
	}
}

/*
 
 func backButtonDidTap() {
	 listener?.userProfileSettingBackButtonDidTap()
 }
 
 func birthdayPickerDidTap() {
	 router?.attachBirthdayPicker()
 }
 
 func dismiss() {
	 listener?.userProfileSettingDismiss()
 }
}

// MARK: - BirthdayPickerListener
extension UserProfileSettingInteractor {
 func didTapBirthdayPicker() {
	 router?.attachBirthdayPicker()
 }
 
 func birthdayPickerDismiss() {
	 router?.detachBirthdayPicker()
 }
}

 */
