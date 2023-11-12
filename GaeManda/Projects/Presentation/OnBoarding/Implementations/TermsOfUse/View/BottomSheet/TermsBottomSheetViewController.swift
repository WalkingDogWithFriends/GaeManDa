//
//  TermsBottomSheetViewController.swift
//  OnBoarding
//
//  Created by 김영균 on 11/2/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import RIBs
import RxCocoa
import RxSwift
import SnapKit
import DesignKit

protocol TermsBottomSheetPresentableListener: AnyObject {
	func viewDidLoad()
	func dismiss()
	func didTapConfirmButton()
}

final class TermsBottomSheetViewController: 
	BottomSheetViewController,
	TermsBottomSheetViewControllable {
	weak var listener: TermsBottomSheetPresentableListener?
	private let disposeBag = DisposeBag()

	private let textView: UITextView = {
		let textView = UITextView()
		textView.backgroundColor = .white
		textView.isEditable = false
		textView.showsHorizontalScrollIndicator = false
		textView.showsVerticalScrollIndicator = false
		textView.font = .r16
		textView.textColor = .black
		
		return textView
	}()
	
	private let confirmButton: UIButton = {
		let button = UIButton()
		button.setTitle("확인", for: .normal)
		button.setTitleColor(.green100, for: .normal)
		button.titleLabel?.font = .b16
		
		return button
	}()
	
	// MARK: - View Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		listener?.viewDidLoad()
	}
	
	// MARK: - Private Methods
	private func setupUI() {
		setViewHierarchy()
		setConstraints()
		bind()
	}
	
	private func setViewHierarchy() {
		self.contentView.addSubviews(textView, confirmButton)
	}
	
	private func setConstraints() {
		self.textView.snp.makeConstraints { make in
			make.top.leading.trailing.equalToSuperview()
			make.height.equalTo(200) // 기본 높이
		}
		
		self.confirmButton.snp.makeConstraints { make in
			make.top.equalTo(textView.snp.bottom).offset(24)
			make.leading.trailing.bottom.equalToSuperview()
		}
	}
	
	private func bind() {
		self.didDismissBottomSheet
			.bind(with: self, onNext: { owner, _ in
				owner.listener?.dismiss()
			})
			.disposed(by: disposeBag)
		
		self.confirmButton.rx.tap
			.bind(with: self) { owner, _ in
				owner.dismissBottomSheet()
				owner.listener?.didTapConfirmButton()
			}
			.disposed(by: disposeBag)
	}
}

extension TermsBottomSheetViewController: TermsBottomSheetPresentable {
	func setTextView(text: String?) {
		self.textView.text = text
	}
}
