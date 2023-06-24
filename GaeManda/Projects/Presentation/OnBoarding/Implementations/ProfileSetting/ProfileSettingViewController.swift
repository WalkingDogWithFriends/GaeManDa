import UIKit
import RIBs
import DesignKit
import Extensions

protocol ProfileSettingPresentableListener: AnyObject { }
final class ProfileSettingViewController:
	UIViewController,
	ProfileSettingPresentable,
	ProfileSettingViewControllable {
	weak var listener: ProfileSettingPresentableListener?
	
	private let label: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "보호자의 프로필을 설정해주세요!"
		label.font = .systemFont(ofSize: 20, weight: .bold)
		label.numberOfLines = 1
		
		return label
	}()
	
	private let profileImageView: RoundImageView = {
		let imageView = RoundImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.image = UIImage(systemName: "photo")
		
		return imageView
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
			rightViewMode: .textCount(maximumTextCount: 20),
			warningText: "닉네임을 입력해주세요."
		)
		onBoardingTextView.translatesAutoresizingMaskIntoConstraints = false

		return onBoardingTextView
	}()
	
	private let calenderTextView: OnBoardingTextView = {
		let onBoardingTextView = OnBoardingTextView(
			title: "생년월일",
			rightViewMode: .calendar,
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
		
		view.addSubview(label)
		view.addSubview(profileImageView)
		view.addSubview(textStackView)
		view.addSubview(buttonStackView)
		view.addSubview(confirmButton)
		
		textStackView.addArrangedSubview(nickNameTextView)
		textStackView.addArrangedSubview(calenderTextView)
		
		buttonStackView.addArrangedSubview(maleButton)
		buttonStackView.addArrangedSubview(femaleButton)
		
		let safeArea = view.safeAreaLayoutGuide
		NSLayoutConstraint.activate([
			label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 31.5),
			label.topAnchor.constraint(equalTo: view.topAnchor, constant: 128),
			
			profileImageView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 40),
			profileImageView.heightAnchor.constraint(equalToConstant: 140),
			profileImageView.widthAnchor.constraint(equalToConstant: 140),
			profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			
			textStackView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 40),
			textStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 38),
			textStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -38),
			
			buttonStackView.topAnchor.constraint(equalTo: textStackView.bottomAnchor, constant: 40),
			buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 38),
			buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -38),
			buttonStackView.heightAnchor.constraint(equalToConstant: 47),
			
			confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
			confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
			confirmButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -20),
			confirmButton.heightAnchor.constraint(equalToConstant: 41)
		])
	}
}

private extension ProfileSettingViewController {
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
}
