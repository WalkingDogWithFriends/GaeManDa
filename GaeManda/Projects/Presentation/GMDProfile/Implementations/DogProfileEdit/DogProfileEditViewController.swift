//
//  DogProfileEditViewController.swift
//  GMDProfileImpl
//
//  Created by jung on 2023/07/30.
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

protocol DogProfileEditPresentableListener: AnyObject {
	func backbuttonDidTap()
}

final class DogProfileEditViewController:
	UIViewController,
	DogProfileEditPresentable,
	DogProfileEditViewControllable {
	weak var listener: DogProfileEditPresentableListener?
	private let disposeBag = DisposeBag()
	
	// MARK: UI Property
	private let dogProfileDashBoard: DogProfileDashBoard = {
		let collectionView = DogProfileDashBoard()
		collectionView.register(
			DogProfileDashBoardCell.self,
			forCellWithReuseIdentifier: DogProfileDashBoardCell.identifier
		)
		
		return collectionView
	}()
	
	private let profileImageView: RoundImageView = {
		let imageView = RoundImageView()
		imageView.backgroundColor = .gray40
		
		return imageView
	}()
	
	private let scrollView = DogProfileEditScrollView()
	
	private let endEditingButton: UIButton = {
		let button = UIButton()
		button.setTitle("수정 완료", for: .normal)
		button.setTitleColor(.white, for: .normal)
		button.layer.cornerRadius = 4
		button.backgroundColor = .green100
		button.titleLabel?.font = .b16
		
		return button
	}()
	
	// MARK: Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupUI()
		addKeyboardObserver()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		hideTabBar()
	}
}

// MARK: Setting UI
private extension DogProfileEditViewController {
	func setupUI() {
		view.backgroundColor = .white
		setupBackNavigationButton(
			target: self,
			action: #selector(backbuttonDidTap)
		)
		
		title = "프로필 수정"
		setNavigationTitleFont(.b20)
		
		setupSubViews()
		setConstraints()
		bind()
	}
	
	func setupSubViews() {
		view.addSubview(dogProfileDashBoard)
		view.addSubview(profileImageView)
		view.addSubview(scrollView)
		view.addSubview(endEditingButton)
	}
	
	func setConstraints() {
		dogProfileDashBoard.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(23)
			make.top.equalToSuperview().offset(107)
			make.height.equalTo(56)
		}
		
		profileImageView.snp.makeConstraints { make in
			make.top.equalTo(dogProfileDashBoard.snp.bottom).offset(23)
			make.centerX.equalToSuperview()
			make.width.height.equalTo(140)
		}
		
		scrollView.snp.makeConstraints { make in
			make.top.equalTo(profileImageView.snp.bottom).offset(32)
			make.leading.equalToSuperview().offset(32)
			make.trailing.equalToSuperview().offset(-32)
			make.bottom.equalTo(endEditingButton.snp.top).offset(-26)
		}
		
		endEditingButton.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(32)
			make.trailing.equalToSuperview().offset(-32)
			make.bottom.equalToSuperview().offset(-54)
			make.height.equalTo(40)
		}
	}
}

// MARK: Bind
private extension DogProfileEditViewController {
	func bind() {
		let images = [
			UIImage(systemName: "person.crop.circle"),
			UIImage(systemName: "person.crop.circle")
		]
		
		Observable<[UIImage?]>.of(images)
			.bind(to: dogProfileDashBoard.rx.items(
				cellIdentifier: DogProfileDashBoardCell.identifier,
				cellType: DogProfileDashBoardCell.self
			)) { (index, item, cell) in
				cell.configuration(image: item)
				if index == 1 {
					cell.isEdited = true
				}
			}
			.disposed(by: disposeBag)
		
		scrollView.rx.didTapCalenderButton
			.withUnretained(self)
			.bind { owner, _ in
				owner.calenderButtonDidTap()
			}
			.disposed(by: disposeBag)
	}
}

// MARK: Action

private extension DogProfileEditViewController {
	@objc func backbuttonDidTap() {
		listener?.backbuttonDidTap()
	}
	
	func calenderButtonDidTap() {
		print("calenderButtonDidTap")
	}
}
 
// MARK: Keyboard Respond
private extension DogProfileEditViewController {
	/// Register Keyboard notifications
	func addKeyboardObserver() {
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(keyboardWillShow),
			name: UIResponder.keyboardWillShowNotification,
			object: nil
		)
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(keyboardWillHide),
			name: UIResponder.keyboardWillHideNotification,
			object: nil
		)
	}
	
	@objc func keyboardWillShow(_ notification: Notification) {
		guard let userInfo = notification.userInfo,
					let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
		else {
			return
		}
		let keyboardHeight = keyboardSize.height
		let scrollviewBottom = scrollView.convert(scrollView.bounds, to: view).maxY
		let bottomFromSuperView = view.frame.size.height - scrollviewBottom
		let padding: CGFloat = 20
		
		/// add Padding from Scroll View Bottom to enable scroll all contents
		scrollView.contentInset.bottom = keyboardHeight - bottomFromSuperView + padding
		
		let firstResponder = UIResponder.currentFirstResponder
		
		/// TextField
		if let textField = firstResponder as? UITextField {
			self.scrollView.scrollRectToVisible(textField.frame, animated: false)
		/// TextView
		} else if let textView = firstResponder as? UITextView {
			let textViewTopFromScrollView = textView.convert(textView.frame, to: scrollView).maxY
			// locate textView Top to top of scrollView
			let moveValue = textViewTopFromScrollView - (scrollView.bounds.size.height / 2)
			
			let point = CGPoint(x: 0, y: moveValue - padding)
			scrollView.setContentOffset(point, animated: true)
		}
	}
	
	@objc func keyboardWillHide() {
		scrollView.contentInset = .zero
	}
}
