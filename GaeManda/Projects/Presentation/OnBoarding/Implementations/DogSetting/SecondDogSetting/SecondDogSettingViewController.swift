import UIKit
import RIBs
import RxCocoa
import RxSwift
import DesignKit
import GMDUtils

protocol SecondDogSettingPresentableListener: AnyObject {
	func confirmButtonDidTap()
	func backButtonDidTap()
}

final class SecondDogSettingViewController:
	KeyboardRespondViewController,
	SecondDogSettingPresentable,
	SecondDogSettingViewControllable {
	weak var listener: SecondDogSettingPresentableListener?
	private let disposeBag = DisposeBag()
	
	private let onBoardingView: OnBoardingView = {
		let onBoardingView = OnBoardingView(
			willDisplayImageView: true,
			title: "우리 아이를 등록해주세요! (2/3)"
		)
		onBoardingView.translatesAutoresizingMaskIntoConstraints = false
		
		return onBoardingView
	}()
	
	private let textStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .vertical
		stackView.alignment = .fill
		stackView.spacing = 16
		stackView.distribution = .fillProportionally
		
		return stackView
	}()
	
	private let dogBreedTextField: OnBoardingTextField = {
		let onBoardingTextField = OnBoardingTextField(
			title: "우리 아이 종",
			warningText: "우리 아이 종을 작성해주세요"
		)
		onBoardingTextField.translatesAutoresizingMaskIntoConstraints = false

		return onBoardingTextField
	}()
	
	private let dogWeightTextField: OnBoardingTextField = {
		let onBoardingTextField = OnBoardingTextField(
			title: "우리 아이 몸무게 (kg)",
			warningText: "우리 아이 몸무게 (kg)을 입력해주세요."
		)
		onBoardingTextField.translatesAutoresizingMaskIntoConstraints = false
		onBoardingTextField.textField.keyboardType = .numberPad

		return onBoardingTextField
	}()
	
	private let suffix = "kg"
	
	private let confirmButton: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setTitle("확인", for: .normal)
		button.setTitleColor(.white, for: .normal)
		button.layer.cornerRadius = 4
		button.backgroundColor = .green100
		button.titleLabel?.font = .b16
		
		return button
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
	}
	
	private func setupUI() {
		view.backgroundColor = .white
		self.setupBackNavigationButton(
			target: self,
			action: #selector(backButtonDidTap)
		)
		setupSubviews()
		setConstraints()
		bind()
	}
	
	private func setupSubviews() {
		view.addSubview(onBoardingView)
		view.addSubview(textStackView)
		view.addSubview(confirmButton)
		
		textStackView.addArrangedSubview(dogBreedTextField)
		textStackView.addArrangedSubview(dogWeightTextField)
	}
	
	private func setConstraints() {
		NSLayoutConstraint.activate([
			onBoardingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			onBoardingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			onBoardingView.topAnchor.constraint(equalTo: view.topAnchor),
			
			textStackView.topAnchor.constraint(equalTo: onBoardingView.bottomAnchor, constant: 48),
			textStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
			textStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
			
			confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
			confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
			confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -54),
			confirmButton.heightAnchor.constraint(equalToConstant: 40)
		])
	}
	
	private func bind() {
		dogWeightTextField.textField.rx.controlEvent(.editingChanged)
			.withUnretained(self)
			.bind { owner, _ in
				owner.addSuffix()
			}
			.disposed(by: disposeBag)
		
		dogWeightTextField.textField.rx.cursorChanged
			.withUnretained(self)
			.bind { owner, range in
				owner.setUneditableSuffix(range)
			}
			.disposed(by: disposeBag)
		
		dogWeightTextField.textField.rx.controlEvent(.editingDidBegin)
			.withUnretained(self)
			.bind { owner, _ in
				owner.editingView = owner.dogWeightTextField
			}
			.disposed(by: disposeBag)
		
		dogWeightTextField.textField.rx.controlEvent(.editingDidEnd)
			.withUnretained(self)
			.bind { owner, _ in
				owner.editingView = nil
			}
			.disposed(by: disposeBag)
		
		confirmButton.rx.tap
			.withUnretained(self)
			.bind { owner, _ in
				owner.listener?.confirmButtonDidTap()
			}
			.disposed(by: disposeBag)
	}
}

// MARK: - Action
private extension SecondDogSettingViewController {
	func addSuffix() {
		guard let text = dogWeightTextField.textField.text else { return }
		
		if text.contains(suffix), text.count == suffix.count {
			dogWeightTextField.textField.text = ""
		} else if !text.contains(suffix) {
			dogWeightTextField.textField.text = text + suffix
		}
	}
	
	func setUneditableSuffix(_ selectedRange: UITextRange?) {
		let textField = dogWeightTextField.textField
		
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
	
	@objc func backButtonDidTap() {
		listener?.backButtonDidTap()
	}
}
