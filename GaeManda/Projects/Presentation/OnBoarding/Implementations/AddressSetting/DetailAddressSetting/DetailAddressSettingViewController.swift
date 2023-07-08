//
//  DetailAddressSettingViewController.swift
//  OnBoarding
//
//  Created by jung on 2023/07/08.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import RIBs
import RxSwift
import RxCocoa
import Utils

protocol DetailAddressSettingPresentableListener: AnyObject {
	func detailAddressSettingDidDismiss()
	func closeButtonDidTap()
}

final class DetailAddressSettingViewController:
	UIViewController,
	DetailAddressSettingPresentable,
	DetailAddressSettingViewControllable {	
	weak var listener: DetailAddressSettingPresentableListener?
	private let disposeBag = DisposeBag()

	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
	}
	
	private func setupUI() {
		view.backgroundColor = .white
		title = "주소 검색"
		setupCloseNavigationButton(
			target: self,
			action: #selector(closeButtonDidTap)
		)
		
		setupSubviews()
		setConstraints()
		bind()
	}
	
	private func setupSubviews() { }
	
	private func setConstraints() { }
	
	private func bind() {
		self.rx.viewDidDisappear
			.subscribe(
				onNext: { [weak self] _ in
					self?.listener?.detailAddressSettingDidDismiss()
				}
			)
			.disposed(by: disposeBag)
	}
}

// MARK: Action
extension DetailAddressSettingViewController {
	@objc func closeButtonDidTap() {
		listener?.closeButtonDidTap()
	}
}
