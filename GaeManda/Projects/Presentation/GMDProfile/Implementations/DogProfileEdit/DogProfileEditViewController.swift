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
	func didTapBackButton()
}

final class DogProfileEditViewController:
	UIViewController,
	DogProfileEditPresentable,
	DogProfileEditViewControllable {
	// MARK: - Properties
	weak var listener: DogProfileEditPresentableListener?
	private let disposeBag = DisposeBag()
	
	// MARK: - UI Components
	private let navigationBar = GMDNavigationBar(title: "프로필 수정")
	
	private let dogProfileDashBoard: DogProfileDashBoard = {
		let collectionView = DogProfileDashBoard()
		collectionView.registerCell(DogProfileDashBoardCell.self)
		
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
	
	// MARK: - Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupUI()
		registerKeyboardNotification()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		hideTabBar()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		removeKeyboardNotification()
	}
}

// MARK: - UI Setting
private extension DogProfileEditViewController {
	func setupUI() {
		view.backgroundColor = .white
		navigationController?.navigationBar.isHidden = true
		
		setViewHierarchy()
		setConstraints()
		bind()
	}
	
	func setViewHierarchy() {
		view.addSubviews(navigationBar, dogProfileDashBoard, profileImageView, scrollView, endEditingButton)
	}
	
	func setConstraints() {
		navigationBar.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.top.equalTo(view.safeAreaLayoutGuide)
			make.height.equalTo(44)
		}
		
		dogProfileDashBoard.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(23)
			make.top.equalToSuperview().offset(107)
			make.height.equalTo(56)
		}
		
		profileImageView.snp.makeConstraints { make in
			make.top.equalTo(dogProfileDashBoard.snp.bottom).offset(20)
			make.centerX.equalToSuperview()
			make.width.height.equalTo(140)
		}
		
		scrollView.snp.makeConstraints { make in
			make.top.equalTo(profileImageView.snp.bottom).offset(32)
			make.leading.equalToSuperview().offset(32)
			make.trailing.equalToSuperview().offset(-32)
			make.bottom.equalTo(endEditingButton.snp.top).offset(-24)
		}
		
		endEditingButton.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(32)
			make.trailing.equalToSuperview().offset(-32)
			make.bottom.equalToSuperview().offset(-54)
			make.height.equalTo(40)
		}
	}
}

// MARK: - Action Bind
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
		
		navigationBar.backButton.rx.tap
			.bind(with: self) { owner, _ in
				owner.listener?.didTapBackButton()
			}
			.disposed(by: disposeBag)
		
		scrollView.rx.didTapCalenderButton
			.bind(with: self) { owner, _ in
				owner.calenderButtonDidTap()
			}
			.disposed(by: disposeBag)
	}
}

// MARK: - UI Logic
private extension DogProfileEditViewController {
	func calenderButtonDidTap() {
		print("calenderButtonDidTap")
	}
}

// MARK: - KeyboardListener
extension DogProfileEditViewController: KeyboardListener {
	func keyboardWillShow(height: CGFloat) {
		let scrollviewBottom = scrollView.convert(scrollView.bounds, to: view).maxY
		let bottomFromSuperView = view.frame.size.height - scrollviewBottom
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
