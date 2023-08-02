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
		
		scrollViewTextFieldBind()
		scrollViewButtonBind()
	}
	
	/// ScrollView TextField Bind
	func scrollViewTextFieldBind() {
		scrollView.nickNameTextField.textField.rx.text
			.orEmpty
			.withUnretained(self)
			.bind { owner, text in
				owner.setTextCountLabel(text)
			}
			.disposed(by: disposeBag)
		
		scrollView.calenderTextField.textField.rx.controlEvent(.editingDidBegin)
			.withUnretained(self)
			.bind { owner, _ in
				owner.scrollView.calenderTextField.textField.endEditing(true)
			}
			.disposed(by: disposeBag)
		
		scrollView.weightTextField.textField.rx.controlEvent(.editingChanged)
			.withUnretained(self)
			.bind { owner, _ in
				owner.addSuffixForWeightTextField()
			}
			.disposed(by: disposeBag)
		
		scrollView.weightTextField.textField.rx.cursorChanged
			.withUnretained(self)
			.bind { owner, range in
				owner.setUneditableSuffix(range)
			}
			.disposed(by: disposeBag)
		
		scrollView.characterTextView.textView.rx.text
			.orEmpty
			.map { $0.count }
			.withUnretained(self)
			.bind { owner, count in
				owner.setTextCountLabel(count)
			}
			.disposed(by: disposeBag)
	}
	
	/// ScrollView Button Action Bind
	func scrollViewButtonBind() {
		scrollView.calenderButton.rx.tap
			.withUnretained(self)
			.bind { owner, _ in
				owner.calenderButtonDidTap()
			}
			.disposed(by: disposeBag)
		
		scrollView.maleButton.rx.tap
			.withUnretained(self)
			.bind { owner, _ in
				owner.maleButtonDidTap()
			}
			.disposed(by: disposeBag)
		
		scrollView.femaleButton.rx.tap
			.withUnretained(self)
			.bind { owner, _ in
				owner.femaleButtonDidTap()
			}
			.disposed(by: disposeBag)
		
		scrollView.didNeuterButton.rx.tap
			.withUnretained(self)
			.bind { owner, _ in
				owner.didNeuterButtonDidTap()
			}
			.disposed(by: disposeBag)
		
		scrollView.didNotNeuterButton.rx.tap
			.withUnretained(self)
			.bind { owner, _ in
				owner.didNotNeuterButtonDidTap()
			}
			.disposed(by: disposeBag)
	}
}

// MARK: Action
private extension DogProfileEditViewController {
	@objc func backbuttonDidTap() {
		listener?.backbuttonDidTap()
	}
	
	func setTextCountLabel(_ text: String) {
		var newText = text
		let textCount = scrollView.maximumTextFieldCount
		
		if text.count >= textCount {
			let index = text.index(text.startIndex, offsetBy: textCount)
			newText = String(text[..<index])
			scrollView.nickNameTextField.textField.text = newText
		}
		scrollView.maximumTextCountLabel.text = "\(newText.count)/\(textCount)"
	}
	
	func calenderButtonDidTap() {
		print("calenderButtonDidTap")
	}
	
	func maleButtonDidTap() {
		if scrollView.maleButton.buttonIsSelected == true { return }
		
		scrollView.maleButton.buttonIsSelected.toggle()
		scrollView.femaleButton.buttonIsSelected = false
	}
	
	func femaleButtonDidTap() {
		if scrollView.femaleButton.buttonIsSelected == true { return }
		
		scrollView.femaleButton.buttonIsSelected.toggle()
		scrollView.maleButton.buttonIsSelected = false
	}
	
	/// add Suffix in Weight TextField
	func addSuffixForWeightTextField() {
		let textField = scrollView.weightTextField.textField
		guard let text = textField.text else { return }
		
		let suffix = scrollView.suffix
		
		if text.contains(suffix), text.count == suffix.count {
			textField.text = ""
		} else if !text.contains(suffix) {
			textField.text = text + suffix
		}
	}
	
	/// uneditable suffic in Weight TextField
	func setUneditableSuffix(_ selectedRange: UITextRange?) {
		let textField = scrollView.weightTextField.textField
		let suffix = scrollView.suffix
		guard
			let text = textField.text,
			let selectedRange = selectedRange,
			let suffixRange = text.range(of: suffix)
		else {
			return
		}
		let suffixStartIndex = text.distance(
			from: text.startIndex,
			to: suffixRange.lowerBound
		)
		let cursorEndPosition = textField.offset(
			from: textField.beginningOfDocument,
			to: selectedRange.end
		)
		
		if
			cursorEndPosition > suffixStartIndex,
			let newPosition = textField.position(from: selectedRange.end, offset: -2) {
			textField.selectedTextRange = textField.textRange(
				from: newPosition,
				to: newPosition
			)
		}
	}
	
	func setTextCountLabel(_ textCount: Int) {
		let textView = scrollView.characterTextView
		let maxTextCount = scrollView.maximumTextViewCount
		
		textView.maximumTextCountLabel.text = "\(textCount)/\(maxTextCount)"
		
		textView.isWarning = textCount > maxTextCount ? true : false
	}
	
	func didNeuterButtonDidTap() {
		if scrollView.didNeuterButton.buttonIsSelected == true { return }
		
		scrollView.didNeuterButton.buttonIsSelected.toggle()
		scrollView.didNotNeuterButton.buttonIsSelected = false
	}
	
	func didNotNeuterButtonDidTap() {
		if scrollView.didNotNeuterButton.buttonIsSelected == true { return }
		
		scrollView.didNotNeuterButton.buttonIsSelected.toggle()
		scrollView.didNeuterButton.buttonIsSelected = false
	}
}
