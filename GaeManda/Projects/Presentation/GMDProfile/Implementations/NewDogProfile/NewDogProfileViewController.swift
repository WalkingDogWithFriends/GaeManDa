//
//  NewDogProfileViewController.swift
//  GMDProfile
//
//  Created by jung on 2023/09/05.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import RIBs
import RxCocoa
import RxSwift
import SnapKit
import DesignKit
import GMDExtensions
import GMDUtils

protocol NewDogProfilePresentableListener: AnyObject {
	func didTapBackButton()
	func didTapConfirmButton()
}

final class NewDogProfileViewController:
	UIViewController,
	NewDogProfilePresentable,
	NewDogProfileViewControllable {
	// MARK: - Properties
	weak var listener: NewDogProfilePresentableListener?
	private let disposeBag = DisposeBag()
	var keyboardShowNotification: NSObjectProtocol?
	var keyboardHideNotification: NSObjectProtocol?
	var textDidChangeNotification: NSObjectProtocol?
	
	// MARK: - UI Components
	private var navigationBar = GMDNavigationBar(title: "프로필 추가")
	private var profileImageView = RoundImageView()
	private var scrollView = DogProfileScrollView()
	private var confirmButton = ConfirmButton(title: "완료")
	
	// MARK: - Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupUI()
		keyboardShowNotification = registerKeyboardShowNotification()
		keyboardHideNotification = registerKeyboardHideNotification()
		textDidChangeNotification = registerTextFieldNotification()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		hideTabBar()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		removeKeyboardNotification([keyboardShowNotification, keyboardHideNotification])
		removeTextFieldNotification([textDidChangeNotification])
	}
	
	// MARK: - touchesBegan
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		self.scrollView.endEditing(true)
	}
}

// MARK: - UI Setting
private extension NewDogProfileViewController {
	func setupUI() {
		setViewHierarchy()
		setConstraints()
		bind()
	}
	
	func setViewHierarchy() {
		view.addSubviews(navigationBar, profileImageView, scrollView, confirmButton)
	}
	
	func setConstraints() {
		navigationBar.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.top.equalTo(view.safeAreaLayoutGuide)
			make.height.equalTo(44)
		}
		
		profileImageView.snp.makeConstraints { make in
			make.top.equalTo(navigationBar.snp.bottom).offset(96)
			make.centerX.equalToSuperview()
			make.width.height.equalTo(140)
		}
		
		scrollView.snp.makeConstraints { make in
			make.top.equalTo(profileImageView.snp.bottom).offset(32)
			make.leading.equalToSuperview().offset(32)
			make.trailing.equalToSuperview().offset(-32)
			make.bottom.equalTo(confirmButton.snp.top).offset(-24)
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
private extension NewDogProfileViewController {
	func bind() {
		navigationBar.backButton.rx.tap
			.bind(with: self) { owner, _ in
				owner.listener?.didTapBackButton()
			}
			.disposed(by: disposeBag)
		
		scrollView.textFieldModeRelay
			.map { $0.isValid }
			.bind(to: confirmButton.rx.isPositive)
			.disposed(by: disposeBag)
		
		let confirmButtonWithViewModel = confirmButton.rx.tap
			.withLatestFrom(scrollView.textFieldModeRelay)
			.share()
		
		confirmButtonWithViewModel
			.filter { $0.isValid }
			.bind(with: self) { owner, _ in
				owner.listener?.didTapConfirmButton()
			}
			.disposed(by: disposeBag)
		
		confirmButtonWithViewModel
			.bind(with: self) { owner, viewModel in
				owner.scrollView.nickNameTextField.mode = viewModel.nickNameTextFieldMode
				owner.scrollView.dogBreedTextField.mode = viewModel.dogBreedTextFieldMode
				owner.scrollView.weightTextField.mode = viewModel.dogWeightTextFieldMode
			}
			.disposed(by: disposeBag)
	}
}

// MARK: - KeyboardListener
extension NewDogProfileViewController: KeyboardListener {
	func keyboardWillShow(height: CGFloat) {
		let scrollViewBottom = scrollView.convert(scrollView.bounds, to: view).maxY
		let bottomFromSuperView = view.frame.size.height - scrollViewBottom
		let padding: CGFloat = 20
		
		/// add Padding from Scroll View Bottom to enable scroll all contents
		scrollView.contentInset.bottom = height - bottomFromSuperView + padding
		
		let firstResponder = UIResponder.currentFirstResponder
		
		if let textView = firstResponder as? UITextView {
			let textViewTopFromScrollView = textView.convert(textView.frame, to: scrollView).maxY
			// locate textView Top to top of scrollView
			let moveValue = textViewTopFromScrollView - (scrollView.bounds.size.height / 2)
			
			let point = CGPoint(x: 0, y: moveValue - padding)
			scrollView.setContentOffset(point, animated: true)
		}
	}
	
	func keyboardWillHide() {
		scrollView.contentInset = .zero
	}
}

// MARK: - GMDTextFieldListener
extension NewDogProfileViewController: GMDTextFieldListener { }
