import UIKit
import RIBs
import DesignKit
import Extensions

protocol UserSettingPresentableListener: AnyObject {
	func didTapConfirmButton()
}

final class UserSettingViewController:
	UIViewController,
	UserSettingPresentable,
	UserSettingViewControllable {
	weak var listener: UserSettingPresentableListener?
	
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
	
	private let nickNameTextView: OnBoardingTextView = {
		let onBoardingTextView = OnBoardingTextView(
			title: "닉네임",
			warningText: "닉네임을 입력해주세요."
		)
		onBoardingTextView.translatesAutoresizingMaskIntoConstraints = false
		
		return onBoardingTextView
	}()
	
	private let nickNameTextViewCountLabel: UILabel = {
		let label = UILabel()
		
		return label
	}()
	
	private let calenderTextView: OnBoardingTextView = {
		let onBoardingTextView = OnBoardingTextView(
			title: "생년월일",
			warningText: "닉네임을 입력해주세요."
		)
		onBoardingTextView.translatesAutoresizingMaskIntoConstraints = false
		
		return onBoardingTextView
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
	
	private lazy var maleButton: OnBoardingButton = {
		let button = OnBoardingButton(title: "남")
		button.translatesAutoresizingMaskIntoConstraints = false
		button.addTarget(
			self,
			action: #selector(maleButtonTapped),
			for: .touchUpInside
		)
		
		return button
	}()
	
	private lazy var femaleButton: OnBoardingButton = {
		let button = OnBoardingButton(title: "여")
		button.translatesAutoresizingMaskIntoConstraints = false
		button.addTarget(
			self,
			action: #selector(femaleButtonTapped),
			for: .touchUpInside
		)
		return button
	}()
	
	private lazy var confirmButton: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setTitle("확인", for: .normal)
		button.setTitleColor(.white, for: .normal)
		button.layer.cornerRadius = 4
		button.backgroundColor = .init(hexCode: "65BF4D")
		button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
		button.addTarget(
			self,
			action: #selector(didTapConfirmButton),
			for: .touchUpInside
		)
		
		return button
	}()
	
	init() {
		super.init(nibName: nil, bundle: nil)
		setupUI()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupUI()
	}
	
	private func setupUI() {
		view.backgroundColor = .white
		setupSubviews()
		setConstraints()
		bind()
	}
	
	private func setupSubviews() {
		view.addSubview(onBoardingView)
		view.addSubview(textStackView)
		view.addSubview(buttonStackView)
		view.addSubview(confirmButton)
		
		textStackView.addArrangedSubview(nickNameTextView)
		textStackView.addArrangedSubview(calenderTextView)
		
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
		
	}
	
}

// MARK: - Action
private extension UserSettingViewController {
	@objc func maleButtonTapped() {
		if maleButton.buttonIsSelected == true { return }
		maleButton.buttonIsSelected.toggle()
		
		if femaleButton.buttonIsSelected == true {
			femaleButton.buttonIsSelected.toggle()
		}
	}
	
	@objc func femaleButtonTapped() {
		if femaleButton.buttonIsSelected == true { return }
		femaleButton.buttonIsSelected.toggle()
		
		if maleButton.buttonIsSelected == true {
			maleButton.buttonIsSelected.toggle()
		}
	}
	
	@objc func didTapConfirmButton() {
		listener?.didTapConfirmButton()
	}
}
