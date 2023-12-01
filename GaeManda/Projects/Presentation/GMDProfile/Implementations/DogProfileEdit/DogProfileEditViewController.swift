//
//  DogProfileEditViewController.swift
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

protocol DogProfileEditPresentableListener: AnyObject {
	func viewDidLoad()
	func viewWillAppear()
	func didTapBackButton()
	func dismiss()
	func didTapEndEditButton(dog: Dog)
	func didTapDogDashBoard(at id: Int)
}

final class DogProfileEditViewController:
	UIViewController,
	DogProfileEditPresentable,
	DogProfileEditViewControllable {
	// MARK: - Properties
	weak var listener: DogProfileEditPresentableListener?
	private let disposeBag = DisposeBag()
	private var dogViewModels: [DogDashBoardViewModel] = []
	var keyboardShowNotification: NSObjectProtocol?
	var keyboardHideNotification: NSObjectProtocol?
	var textDidChangeNotification: NSObjectProtocol?
	
	// MARK: - UI Components
	private let navigationBar = GMDNavigationBar(title: "프로필 수정")
	
	private let dogProfileDashBoard: DogProfileDashBoard = {
		let collectionView = DogProfileDashBoard()
		collectionView.registerCell(DogProfileDashBoardCell.self)
		
		return collectionView
	}()
	
	private let profileImageView = RoundImageView()
	private let scrollView = DogProfileScrollView()
	
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
		listener?.viewDidLoad()
		
		dogProfileDashBoard.rx.setDataSource(self).disposed(by: disposeBag)
		dogProfileDashBoard.rx.setDelegate(self).disposed(by: disposeBag)
		
		setupUI()
		keyboardShowNotification = registerKeyboardHideNotification()
		keyboardHideNotification = registerKeyboardHideNotification()
		textDidChangeNotification = registerTextFieldNotification()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		listener?.viewWillAppear()
		
		hideTabBar()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		removeKeyboardNotification([keyboardShowNotification, keyboardHideNotification])
		removeTextFieldNotification([textDidChangeNotification])
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		
		if isBeingDismissed || isMovingFromParent {
			listener?.dismiss()
		}
	}
	
	// MARK: touchedBegan
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		self.scrollView.endEditing(true)
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
			make.leading.equalToSuperview().offset(24)
			make.trailing.equalToSuperview()
			make.top.equalTo(navigationBar.snp.bottom).offset(16)
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

// MARK: - UI Update
extension DogProfileEditViewController {
	func updateDogDashBoard(dogViewModels: [DogDashBoardViewModel]) {
		self.dogViewModels = dogViewModels
		dogProfileDashBoard.reloadData()
	}
	
	func updateDogName(_ name: String) {
		scrollView.nickNameTextField.text = name
	}
	
	func updateDogSex(_ sex: Gender) {
		scrollView.selectedSexRelay.accept(sex)
	}
	
	func updateDogWeight(_ weight: String) {
		scrollView.weightTextField.text = "\(weight)kg"
	}
	
	func updateDogNeutered(_ isNeutered: Bool) {
		scrollView.selectedNeuterRelay.accept(isNeutered)
	}
	
	func updateDogCharacter(_ character: String) {
		scrollView.characterTextView.text = character
	}
}

// MARK: - Action Bind
private extension DogProfileEditViewController {
	func bind() {
		navigationBar.backButton.rx.tap
			.bind(with: self) { owner, _ in
				owner.listener?.didTapBackButton()
			}
			.disposed(by: disposeBag)
		
		profileImageView.rx.tapGesture()
			.when(.recognized)
			.bind(with: self) { owner, _ in
				owner.presentPHPickerView()
			}
			.disposed(by: disposeBag)
		
		scrollView.rx.didTapCalenderButton
			.bind(with: self) { owner, _ in
				owner.calenderButtonDidTap()
			}
			.disposed(by: disposeBag)
		
		endEditingButton.rx.tap
			.withLatestFrom(scrollView.textFieldModeRelay)
			.filter { $0.isValid }
			.bind(with: self) { owner, _ in
				// 에러 정책 결정하고 구현하면 될거 같아요
				guard let id = owner.dogViewModels.first(where: { $0.isEdited == true })?.dogId else { return }
				
				owner.listener?.didTapEndEditButton(
					dog: Dog(
						id: 1,
						name: "",
						species: .ETC,
						gender: .male,
						birthday: "",
						weight: 1,
						isNeutered: true,
						characterIds: [],
						profileImage: ""
					)
				)
			}
			.disposed(by: disposeBag)
		
		endEditingButton.rx.tap
			.withLatestFrom(scrollView.textFieldModeRelay)
			.bind(with: self) { owner, viewModel in
				owner.scrollView.nickNameTextField.mode = viewModel.nickNameTextFieldMode
				owner.scrollView.dogBreedTextField.mode = viewModel.dogBreedTextFieldMode
				owner.scrollView.weightTextField.mode = viewModel.dogWeightTextFieldMode
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

// MARK: UICollectionViewDataSource
extension DogProfileEditViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return dogViewModels.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueCell(DogProfileDashBoardCell.self, for: indexPath)
		
		cell.configure(with: dogViewModels[indexPath.row])
		
		return cell
	}
}

// MARK: - UICollectionViewDelegate
extension DogProfileEditViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let dog = dogViewModels[indexPath.row]
		
		listener?.didTapDogDashBoard(at: dog.dogId)
	}
}

// MARK: - KeyboardListener
extension DogProfileEditViewController: KeyboardListener {
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
extension DogProfileEditViewController: GMDTextFieldListener { }

// MARK: - PHPickerViewControllerDelegate
extension DogProfileEditViewController: PHPickerViewControllerDelegate {
	func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
		picker.dismiss(animated: true)
		guard let firstResult = results.first else { return }
		firstResult.fetchImage { result in
			switch result {
			case let .success(image):
				DispatchQueue.main.async {
					self.profileImageView.image = image
				}
			case .failure: break
			}
		}
	}
}
