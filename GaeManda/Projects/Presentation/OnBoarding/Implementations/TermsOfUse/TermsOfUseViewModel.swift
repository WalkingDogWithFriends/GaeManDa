//
//  TermsOfUseViewModel.swift
//  OnBoardingImpl
//
//  Created by 김영균 on 10/26/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RxRelay

final class TermsOfUseViewModel {
	var is약관전체동의Chekced: Bool = false {
		didSet {
			is약관전체동의ChekcedRelay.accept(is약관전체동의Chekced)
		}
	}
	var is이용약관동의Checked: Bool = false {
		didSet {
			is이용약관동의CheckedRelay.accept(is이용약관동의Checked)
			is약관전체동의Chekced = isAllChecked
		}
	}
	var is개인정보수집및이용동의Checked: Bool = false {
		didSet {
			is개인정보수집및이용동의CheckedRelay .accept(is개인정보수집및이용동의Checked)
			is약관전체동의Chekced = isAllChecked
		}
	}
	var is위치정보수집및이용동의Checked: Bool = false {
		didSet {
			is위치정보수집및이용동의CheckedRelay.accept(is위치정보수집및이용동의Checked)
			is약관전체동의Chekced = isAllChecked
		}
	}
	var is마케팅정보수신동의Checked: Bool = false {
		didSet {
			is마케팅정보수신동의CheckedRelay.accept(is마케팅정보수신동의Checked)
			is약관전체동의Chekced = isAllChecked
		}
	}
	var isConfirmButtonEnabled: Bool {
		return is이용약관동의Checked && is개인정보수집및이용동의Checked && is위치정보수집및이용동의Checked
	}
	
	var is약관전체동의ChekcedRelay = PublishRelay<Bool>()
	var is이용약관동의CheckedRelay = PublishRelay<Bool>()
	var is개인정보수집및이용동의CheckedRelay = PublishRelay<Bool>()
	var is위치정보수집및이용동의CheckedRelay = PublishRelay<Bool>()
	var is마케팅정보수신동의CheckedRelay = PublishRelay<Bool>()
	var isConfirmButtonEnabledRelay = PublishRelay<Bool>()
	
	var isAllChecked: Bool {
		is이용약관동의Checked &&
		is개인정보수집및이용동의Checked &&
		is위치정보수집및이용동의Checked &&
		is마케팅정보수신동의Checked
	}
	
	func allChecked(with isChecked: Bool) {
		is이용약관동의Checked = isChecked
		is개인정보수집및이용동의Checked = isChecked
		is위치정보수집및이용동의Checked = isChecked
		is마케팅정보수신동의Checked = isChecked
	}
	
	func a약관전체동의ButtonDidTap() {
		is약관전체동의Chekced.toggle()
		allChecked(with: is약관전체동의Chekced)
		isConfirmButtonEnabledRelay.accept(isConfirmButtonEnabled)
	}
	
	func a이용약관동의ButtonDidTap() {
		is이용약관동의Checked.toggle()
		isConfirmButtonEnabledRelay.accept(isConfirmButtonEnabled)
	}
	
	func a개인정보수집및이용동의ButtonDidTap() {
		is개인정보수집및이용동의Checked.toggle()
		isConfirmButtonEnabledRelay.accept(isConfirmButtonEnabled)
	}
	
	func a위치정보수집및이용동의ButtonDidTap() {
		is위치정보수집및이용동의Checked.toggle()
		isConfirmButtonEnabledRelay.accept(isConfirmButtonEnabled)
	}
	
	func a마케팅정보수신동의ButtonDidTap() {
		is마케팅정보수신동의Checked.toggle()
		isConfirmButtonEnabledRelay.accept(isConfirmButtonEnabled)
	}
}