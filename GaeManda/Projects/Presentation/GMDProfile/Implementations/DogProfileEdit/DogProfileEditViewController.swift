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
import Entity
import GMDExtensions
import GMDUtils

protocol DogProfileEditPresentableListener: AnyObject {
	func viewWillAppear()
	func didTapBackButton()
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
	private var dogs: [Dog] = []
	private var editDogId: Int = 0
	
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
		dogProfileDashBoard.rx.setDataSource(self).disposed(by: disposeBag)
		dogProfileDashBoard.rx.setDelegate(self).disposed(by: disposeBag)
		
		setupUI()
		registerKeyboardNotification()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		listener?.viewWillAppear()
		
		hideTabBar()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		removeKeyboardNotification()
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
	func updateDogDashBoard(doges: [Dog], editIndex: Int) {
		self.dogs = doges
		self.editDogId = editIndex
		dogProfileDashBoard.reloadData()
	}
	
	func updateDogName(_ name: String) {
		scrollView.nickNameTextField.text = name
		scrollView.nickNameTextField.titleLabel.alpha = name.isEmpty ? 0.0 : 1.0
		scrollView.maxTextCountLabel.text = "\(name.count)/\(ScrollViewConstant.maximumTextFieldCount)"
	}
	
	func updateDogSex(_ sex: Sex) {
		scrollView.dogSex = sex
		if sex == .male {
			scrollView.maleButton.rx.isSelected.onNext(true)
			scrollView.femaleButton.rx.isSelected.onNext(false)
		} else {
			scrollView.femaleButton.rx.isSelected.onNext(true)
			scrollView.maleButton.rx.isSelected.onNext(false)
		}
	}
	
	func updateDogWeight(_ weight: String) {
		scrollView.weightTextField.text = "\(weight)kg"
		scrollView.weightTextField.titleLabel.alpha = weight.isEmpty ? 0.0 : 1.0
	}
	
	func updateDogNeutered(_ isNeutered: Bool) {
		scrollView.dogNeutered = isNeutered
		if isNeutered == true {
			scrollView.didNeuterButton.rx.isSelected.onNext(true)
			scrollView.didNotNeuterButton.rx.isSelected.onNext(false)
		} else {
			scrollView.didNotNeuterButton.rx.isSelected.onNext(true)
			scrollView.didNeuterButton.rx.isSelected.onNext(false)
		}
	}
	
	func updateDogCharacter(_ character: String) {
		// TODO: GMDTextView 리팩토링 후 수정
		scrollView.characterTextView.textView.text = character
	}
	
	func dogNameIsEmpty() {
		scrollView.nickNameTextField.mode = .warning
	}
	
	func dogWeightIsEmpty() {
		scrollView.weightTextField.mode = .warning
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
		
		scrollView.rx.didTapCalenderButton
			.bind(with: self) { owner, _ in
				owner.calenderButtonDidTap()
			}
			.disposed(by: disposeBag)
		
		endEditingButton.rx.tap
			.bind(with: self) { owner, _ in
				owner.listener?.didTapEndEditButton(
					dog: Dog(
						id: owner.editDogId,
						name: owner.scrollView.nickNameTextField.text,
						sex: owner.scrollView.dogSex,
						age: "12",
						weight: owner.scrollView.weightTextField.text,
						didNeutered: owner.scrollView.dogNeutered,
						character: owner.scrollView.characterTextView.textView.text
					)
				)
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
		return dogs.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueCell(DogProfileDashBoardCell.self, for: indexPath)
		
		let dog = dogs[indexPath.row]
		cell.configure(with: dog)
		cell.isEdited = dog.id == editDogId ? true : false
		
		return cell
	}
}

// MARK: - UICollectionViewDelegate
extension DogProfileEditViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let dog = dogs[indexPath.row]
		
		listener?.didTapDogDashBoard(at: dog.id)
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
