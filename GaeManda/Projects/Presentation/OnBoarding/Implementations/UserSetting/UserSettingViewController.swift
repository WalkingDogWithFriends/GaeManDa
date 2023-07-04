import UIKit
import RIBs
import RxCocoa
import RxSwift
import DesignKit
import Extensions
import Utils

protocol UserSettingPresentableListener: AnyObject {
	func confirmButtonDidTap()
	func backButtonDidTap()
}

final class UserSettingViewController:
	UIViewController,
	UserSettingPresentable,
	UserSettingViewControllable {
	weak var listener: UserSettingPresentableListener?
	private let disposeBag = DisposeBag()
	
	private let onBoardingView: OnBoardingView = {
		let onBoardingView = OnBoardingView(title: "보호자의 프로필을 설정해주세요!")
		onBoardingView.translatesAutoresizingMaskIntoConstraints = false
		let image = UIImage(systemName: "photo")
		onBoardingView.setProfileImage(image)
		
		return onBoardingView
	}()
	
	private let textStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .vertical
		stackView.alignment = .fill
		stackView.spacing = 0
		stackView.distribution = .fillProportionally
		
		return stackView
	}()
	
	private let nickNameTextField: OnBoardingTextField = {
		let onBoardingTextField = OnBoardingTextField(
			title: "닉네임",
			warningText: "닉네임을 입력해주세요."
		)
		onBoardingTextField.translatesAutoresizingMaskIntoConstraints = false
		
		return onBoardingTextField
	}()
	
	private var maximumTextCount = 20
	
	private lazy var maximumTextCountLabel: UILabel = {
		let label = UILabel()
		label.textColor = .init(hexCode: "979797")
		label.font = .systemFont(ofSize: 15)
		
		return label
	}()
	
	private let calenderTextField: OnBoardingTextField = {
		let onBoardingTextField = OnBoardingTextField(
			title: "생년월일",
			warningText: "생년월일을 입력해주세요."
		)
		onBoardingTextField.translatesAutoresizingMaskIntoConstraints = false
		
		return onBoardingTextField
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
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .horizontal
		stackView.alignment = .fill
		stackView.spacing = 8
		stackView.distribution = .fillEqually
		
		return stackView
	}()
	
	private let maleButton: OnBoardingButton = {
		let button = OnBoardingButton(title: "남")
		button.translatesAutoresizingMaskIntoConstraints = false
		
		return button
	}()
	
	private let femaleButton: OnBoardingButton = {
		let button = OnBoardingButton(title: "여")
		button.translatesAutoresizingMaskIntoConstraints = false
		
		return button
	}()
	
	private let confirmButton: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setTitle("확인", for: .normal)
		button.setTitleColor(.white, for: .normal)
		button.layer.cornerRadius = 4
		button.backgroundColor = .init(hexCode: "65BF4D")
		button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)

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
		
		nickNameTextField.textField.rightView = maximumTextCountLabel
		nickNameTextField.textField.rightViewMode = .always
		
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
		
		textStackView.addArrangedSubview(nickNameTextField)
		textStackView.addArrangedSubview(calenderTextField)
		
		buttonStackView.addArrangedSubview(maleButton)
		buttonStackView.addArrangedSubview(femaleButton)
	}
	
	private func setConstraints() {
		NSLayoutConstraint.activate([
			onBoardingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			onBoardingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			onBoardingView.topAnchor.constraint(equalTo: view.topAnchor),
			
			textStackView.topAnchor.constraint(equalTo: onBoardingView.bottomAnchor, constant: 40),
			textStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 38),
			textStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -38),
			
			buttonStackView.topAnchor.constraint(equalTo: textStackView.bottomAnchor, constant: 40),
			buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 38),
			buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -38),
			buttonStackView.heightAnchor.constraint(equalToConstant: 47),
			
			confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
			confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
			confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -45),
			confirmButton.heightAnchor.constraint(equalToConstant: 40)
		])
	}
	
	private func bind() {
		nickNameTextField.textField.rx.text
			.orEmpty
			.bind { [weak self] text in
				self?.setTextCountLabel(text)
			}
			.disposed(by: disposeBag)
		
		calenderButton.rx.tap
			.bind { [weak self] _ in
				self?.calenderButtonDidTap()
			}
			.disposed(by: disposeBag)
		
		maleButton.rx.tap
			.bind { [weak self] _ in
				self?.maleButtonDidTap()
			}
			.disposed(by: disposeBag)
		
		femaleButton.rx.tap
			.bind { [weak self] _ in
				self?.femaleButtonDidTap()
			}
			.disposed(by: disposeBag)
		
		confirmButton.rx.tap
			.bind { [weak self] _ in
				self?.listener?.confirmButtonDidTap()
			}
			.disposed(by: disposeBag)
	}
}

// MARK: - Action
private extension UserSettingViewController {
	func setTextCountLabel(_ text: String) {
		var newText = text
		
		if text.count >= maximumTextCount {
			let index = text.index(text.startIndex, offsetBy: maximumTextCount)
			newText = String(text[..<index])
			nickNameTextField.textField.text = newText
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
