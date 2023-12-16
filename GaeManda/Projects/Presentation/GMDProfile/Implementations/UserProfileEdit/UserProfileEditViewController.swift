//
//  UserProfileEditViewController.swift
//  GMDProfileImpl
//
//  Created by jung on 2023/07/30.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import PhotosUI
import UIKit
import RIBs
import RxCocoa
import RxSwift
import SnapKit
import DesignKit
import Entity
import GMDExtensions
import GMDUtils

protocol UserProfileEditPresentableListener: AnyObject {
	func viewWillAppear()
	func didTapBackbutton()
	func dismiss()
	func didTapEndEditingButton(name: String, sex: Gender)
}

final class UserProfileEditViewController:
	UIViewController,
	UserProfileEditViewControllable {
	// MARK: - Properties
	weak var listener: UserProfileEditPresentableListener?
	private let disposeBag = DisposeBag()
	
	private let maxTextCount = 20
	private let selectedSexRelay = BehaviorRelay<Gender>(value: .male)
	
	// MARK: - UI Components
	private let navigationBar = GMDNavigationBar(title: "프로필 수정")
	private let profileImageView = ProfileImageView(mode: .editable)
	private let confirmButton = ConfirmButton(title: "수정 완료")
	
	// MARK: - Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		listener?.viewWillAppear()
		
		hideTabBar()
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		
		if isBeingDismissed || isMovingFromParent {
			listener?.dismiss()
		}
	}
	
	// MARK: - touchesBegan
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		self.view.endEditing(true)
	}
	
	func addUserProfileDashboard(_ viewControllable: ViewControllable) {
		let viewController = viewControllable.uiviewController
		
		addChild(viewController)
		view.addSubview(viewController.view)
		
		viewController.view.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(32)
			make.trailing.equalToSuperview().offset(-32)
			make.top.equalTo(profileImageView.snp.bottom).offset(48)
		}
		
		viewController.didMove(toParent: self)
	}
}

// MARK: - UserProfileEditPresentable
extension UserProfileEditViewController: UserProfileEditPresentable { }

// MARK: - UI Setting
private extension UserProfileEditViewController {
	func setupUI() {
		view.backgroundColor = .white
		self.navigationController?.navigationBar.isHidden = true
		
		setViewHierarchy()
		setConstraints()
		bind()
		bindForUI()
	}
	
	func setViewHierarchy() {
		view.addSubviews(navigationBar, profileImageView, confirmButton)
	}
	
	func setConstraints() {
		navigationBar.snp.makeConstraints { make in
			make.top.equalTo(view.safeAreaLayoutGuide)
			make.leading.trailing.equalToSuperview()
			make.height.equalTo(44)
		}
		
		profileImageView.snp.makeConstraints { make in
			make.top.equalTo(navigationBar.snp.bottom).offset(88)
			make.centerX.equalToSuperview()
			make.height.width.equalTo(140)
		}
		
		confirmButton.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(32)
			make.trailing.equalToSuperview().offset(-32)
			make.bottom.equalToSuperview().offset(-54)
			make.height.equalTo(40)
		}
	}
}

// MARK: - Action Bind
private extension UserProfileEditViewController {
	func bind() {
		// 뒤로가기 버튼
		navigationBar.backButton.rx.tap
			.bind(with: self) { owner, _ in
				owner.listener?.didTapBackbutton()
			}
			.disposed(by: disposeBag)
	}
	
	// MARK: - UI Binding
	func bindForUI() {
		// profileImageView 눌렀을 때
		profileImageView.rx.tapGesture()
			.when(.recognized)
			.bind(with: self) { owner, _ in
				owner.presentPHPickerView()
			}
			.disposed(by: disposeBag)
	}
}

// MARK: - PHPickerViewControllerDelegate
extension UserProfileEditViewController: PHPickerViewControllerDelegate {
	func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
		picker.dismiss(animated: true)
		guard let firstResult = results.first else { return }
		firstResult.fetchImage { result in
			switch result {
				case let .success(image):
					self.profileImageView.image = image
				case .failure: break
			}
		}
	}
}
