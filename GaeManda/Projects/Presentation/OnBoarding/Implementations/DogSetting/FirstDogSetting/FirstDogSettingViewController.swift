import UIKit
import RIBs
import RxCocoa
import RxSwift
import SnapKit
import DesignKit
import GMDUtils

protocol FirstDogSettingPresentableListener: AnyObject {
	func confirmButtonDidTap()
	func backButtonDidTap()
}

final class FirstDogSettingViewController:
	UIViewController,
	FirstDogSettingPresentable,
	FirstDogSettingViewControllable {
	weak var listener: FirstDogSettingPresentableListener?
	private let disposeBag = DisposeBag()

	private let onBoardingView: OnBoardingView = {
		let onBoardingView = OnBoardingView(
			willDisplayImageView: true,
			title: "우리 아이를 등록해주세요! (1/3)"
		)
		
		return onBoardingView
	}()
	
	private let textStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.alignment = .fill
		stackView.spacing = 16
		stackView.distribution = .fillProportionally
		
		return stackView
	}()
	
	private let dogNameTextField: GMDTextField = {
		let gmdTextField = GMDTextField(
			title: "우리 아이 이름",
			warningText: "우리 아이 이름을 작성해주세요"
		)

		return gmdTextField
	}()
	
	private var maximumTextCount = 20
	
	private lazy var maximumTextCountLabel: UILabel = {
		let label = UILabel()
		label.textColor = .gray90
		label.font = .r15
		
		return label
	}()
	
	private let calenderTextField: GMDTextField = {
		let gmdTextField = GMDTextField(
			title: "우리 아이 생년월일",
			warningText: "우리아이 생년월일을 입력해주세요."
		)

		return gmdTextField
	}()
	
	private let calenderButton: UIButton = {
		let button = UIButton()
		let image = UIImage(systemName: "calendar")
		button.tintColor = .black
		button.setImage(image, for: .normal)
		
		return button
	}()
	
	private let buttonStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .horizontal
		stackView.alignment = .fill
		stackView.spacing = 26
		stackView.distribution = .fillEqually
		
		return stackView
	}()
	
	private let maleButton: OnBoardingButton = {
		let button = OnBoardingButton(title: "남")
		button.buttonIsSelected = true

		return button
	}()
	
	private let femaleButton: OnBoardingButton = {
		let button = OnBoardingButton(title: "여")

		return button
	}()
	
	private let confirmButton: UIButton = {
		let button = UIButton()
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
		
		dogNameTextField.textField.rightView = maximumTextCountLabel
		dogNameTextField.textField.rightViewMode = .always
		
		calenderTextField.textField.rightView = calenderButton
		calenderTextField.textField.rightViewMode = .always
		
		setupSubviews()
		setConstraints()
		bind()
	}
	
	private func setupSubviews() {
		view.addSubview(onBoardingView)
		view.addSubview(textStackView)
		view.addSubview(buttonStackView)
		view.addSubview(confirmButton)
		
		textStackView.addArrangedSubview(dogNameTextField)
		textStackView.addArrangedSubview(calenderTextField)
		
		buttonStackView.addArrangedSubview(maleButton)
		buttonStackView.addArrangedSubview(femaleButton)
	}
	
	private func setConstraints() {
		onBoardingView.snp.makeConstraints { make in
				make.leading.equalToSuperview()
				make.trailing.equalToSuperview()
				make.top.equalToSuperview()
		}

		textStackView.snp.makeConstraints { make in
				make.top.equalTo(onBoardingView.snp.bottom).offset(48)
				make.leading.equalToSuperview().offset(32)
				make.trailing.equalToSuperview().offset(-32)
		}

		buttonStackView.snp.makeConstraints { make in
				make.top.equalTo(textStackView.snp.bottom).offset(44)
				make.leading.equalToSuperview().offset(32)
				make.trailing.equalToSuperview().offset(-32)
				make.height.equalTo(40)
		}

		confirmButton.snp.makeConstraints { make in
				make.leading.equalToSuperview().offset(32)
				make.trailing.equalToSuperview().offset(-32)
				make.bottom.equalToSuperview().offset(-54)
				make.height.equalTo(40)
		}
	}
	
	private func bind() {
		dogNameTextField.textField.rx.text
			.orEmpty
			.withUnretained(self)
			.bind { owner, text in
				owner.setTextCountLabel(text)
			}
			.disposed(by: disposeBag)
		
		calenderTextField.textField.rx.controlEvent(.editingDidBegin)
			.withUnretained(self)
			.bind { owner, _ in
				owner.calenderTextField.textField.endEditing(true)
			}
			.disposed(by: disposeBag)
		
		calenderButton.rx.tap
			.withUnretained(self)
			.bind { owner, _ in
				owner.calenderButtonDidTap()
			}
			.disposed(by: disposeBag)
		
		maleButton.rx.tap
			.withUnretained(self)
			.bind { owner, _ in
				owner.maleButtonDidTap()
			}
			.disposed(by: disposeBag)
		
		femaleButton.rx.tap
			.withUnretained(self)
			.bind { owner, _ in
				owner.femaleButtonDidTap()
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
private extension FirstDogSettingViewController {
	func setTextCountLabel(_ text: String) {
		var newText = text
		
		if text.count >= maximumTextCount {
			let index = text.index(text.startIndex, offsetBy: maximumTextCount)
			newText = String(text[..<index])
			dogNameTextField.textField.text = newText
		}
		maximumTextCountLabel.text = "\(newText.count)/\(maximumTextCount)"
	}
	
	func calenderButtonDidTap() {
		print("calenderButtonDidTap")
	}
	
	func maleButtonDidTap() {
		if maleButton.buttonIsSelected == true { return }
		
		maleButton.buttonIsSelected.toggle()
		if femaleButton.buttonIsSelected == true {
			femaleButton.buttonIsSelected = false
		}
	}
	
	func femaleButtonDidTap() {
		if femaleButton.buttonIsSelected == true { return }
		
		femaleButton.buttonIsSelected.toggle()
		if maleButton.buttonIsSelected == true {
			maleButton.buttonIsSelected = false
		}
	}
	
	@objc func backButtonDidTap() {
		listener?.backButtonDidTap()
	}
}
