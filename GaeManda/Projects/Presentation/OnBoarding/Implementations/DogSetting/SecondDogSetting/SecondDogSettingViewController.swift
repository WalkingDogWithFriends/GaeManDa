import UIKit
import RIBs
import RxCocoa
import RxSwift
import DesignKit
import Utils

protocol SecondDogSettingPresentableListener: AnyObject {
	func confirmButtonDidTap()
	func backButtonDidTap()
}

final class SecondDogSettingViewController:
	UIViewController,
	SecondDogSettingPresentable,
	SecondDogSettingViewControllable {
	weak var listener: SecondDogSettingPresentableListener?
	private let disposeBag = DisposeBag()
	
	private let onBoardingView: OnBoardingView = {
		let onBoardingView = OnBoardingView(title: "우리 아이를 등록해주세요! (2/3)")
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
		
		return onBoardingTextField
	}()
	
	private let suffix = "kg"
	
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
		setupSubviews()
		setConstraints()
		bind()
	}
	
	private func setupSubviews() {
		view.addSubview(onBoardingView)
		view.addSubview(textStackView)
		view.addSubview(confirmButton)
		
		self.setupBackNavigationButton(
			target: self,
			action: #selector(backButtonDidTap)
		)
		
		textStackView.addArrangedSubview(dogBreedTextField)
		textStackView.addArrangedSubview(dogWeightTextField)
	}
	
	private func setConstraints() {
		NSLayoutConstraint.activate([
			onBoardingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			onBoardingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			onBoardingView.topAnchor.constraint(equalTo: view.topAnchor),
			
			textStackView.topAnchor.constraint(equalTo: onBoardingView.bottomAnchor, constant: 40),
			textStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 38),
			textStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -38),
			
			confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
			confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
			confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -45),
			confirmButton.heightAnchor.constraint(equalToConstant: 40)
		])
	}
	
	private func bind() {
		dogWeightTextField.textField.rx.text
			.orEmpty
			.bind { [weak self] text in
				self?.addSuffix(text)
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
private extension SecondDogSettingViewController {
	func addSuffix(_ text: String) {
		if text.isEmpty { return }
		
		if text.contains(suffix), text.count == suffix.count {
			dogWeightTextField.textField.text = ""
		} else if !text.contains(suffix) {
			dogWeightTextField.textField.text = text + suffix
		}
	}
	
	func setUneditableSuffix() {}
	
	@objc func backButtonDidTap() {
		listener?.backButtonDidTap()
	}
}
