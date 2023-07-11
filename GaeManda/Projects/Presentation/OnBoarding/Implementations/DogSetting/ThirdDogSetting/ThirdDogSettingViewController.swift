import UIKit
import RIBs
import RxCocoa
import RxSwift
import DesignKit
import Utils

protocol ThirdDogSettingPresentableListener: AnyObject {
	func confirmButtonDidTap()
	func backButtonDidTap()
}

final class ThirdDogSettingViewController:
	KeyboardRespondViewController,
	ThirdDogSettingPresentable,
	ThirdDogSettingViewControllable {
	weak var listener: ThirdDogSettingPresentableListener?
	private let disposeBag = DisposeBag()
		
	private let onBoardingView: OnBoardingView = {
		let onBoardingView = OnBoardingView(
			willDisplayImageView: true,
			title: "우리 아이를 등록해주세요! (3/3)"
		)
		onBoardingView.translatesAutoresizingMaskIntoConstraints = false
		
		return onBoardingView
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
	
	private let didNeuterButton: OnBoardingButton = {
		let button = OnBoardingButton(title: "중성화 했어요")
		button.translatesAutoresizingMaskIntoConstraints = false
		
		return button
	}()
	
	private let didNotNeuterButton: OnBoardingButton = {
		let button = OnBoardingButton(title: "중성화 안 했어요")
		button.translatesAutoresizingMaskIntoConstraints = false
		
		return button
	}()
	
	private let characterTextView: OnBoardingTextView = {
		let onBoardingTextView = OnBoardingTextView(title: "우리 아이 성격 (선택)")
		onBoardingTextView.translatesAutoresizingMaskIntoConstraints = false
		
		return onBoardingTextView
	}()
	
	private var maximumTextCount: Int = 20
	
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
		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(keyboardWillShow),
			name: UIResponder.keyboardWillShowNotification,
			object: nil
		)
		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(keyboardWillHidden),
			name: UIResponder.keyboardWillHideNotification,
			object: nil
		)
	}
	
	private func setupUI() {
		view.backgroundColor = .white
		self.setupBackNavigationButton(
			target: self,
			action: #selector(backButtonDidTap)
		)
		self.paddingValue = 10
		
		characterTextView.warningText = "\(maximumTextCount)자 이내로 입력 가능합니다."
		characterTextView.maximumTextCountLabel.text = "0/\(maximumTextCount)"
		setupSubviews()
		setConstraints()
		bind()
	}
	
	private func setupSubviews() {
		view.addSubview(onBoardingView)
		view.addSubview(buttonStackView)
		view.addSubview(characterTextView)
		view.addSubview(confirmButton)
		
		buttonStackView.addArrangedSubview(didNeuterButton)
		buttonStackView.addArrangedSubview(didNotNeuterButton)
	}
	
	private func setConstraints() {
		NSLayoutConstraint.activate([
			onBoardingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			onBoardingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			onBoardingView.topAnchor.constraint(equalTo: view.topAnchor),
			
			buttonStackView.topAnchor.constraint(equalTo: onBoardingView.bottomAnchor, constant: 40),
			buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 38),
			buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -38),
			buttonStackView.heightAnchor.constraint(equalToConstant: 47),
			
			characterTextView.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: 40),
			characterTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 38),
			characterTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -38),
			
			confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
			confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
			confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -45),
			confirmButton.heightAnchor.constraint(equalToConstant: 40)
		])
	}
	
	private func bind() {
		characterTextView.textView.rx.didBeginEditing
			.withUnretained(self)
			.bind { owner, _ in
				owner.editingView = owner.characterTextView.textView
			}
			.disposed(by: disposeBag)
		
		characterTextView.textView.rx.didEndEditing
			.withUnretained(self)
			.bind { owner, _ in
				owner.editingView = nil
			}
			.disposed(by: disposeBag)

		characterTextView.textView.rx.text
			.orEmpty
			.map { $0.count }
			.withUnretained(self)
			.bind { owner, count in
				owner.setTextCountLabel(count)
			}
			.disposed(by: disposeBag)
		
		didNeuterButton.rx.tap
			.withUnretained(self)
			.bind { owner, _ in
				owner.didNeuterButtonDidTap()
			}
			.disposed(by: disposeBag)
		
		didNotNeuterButton.rx.tap
			.withUnretained(self)
			.bind { owner, _ in
				owner.didNotNeuterButtonDidTap()
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
private extension ThirdDogSettingViewController {
	func setTextCountLabel(_ textCount: Int) {
		characterTextView.maximumTextCountLabel.text = "\(textCount)/\(maximumTextCount)"
		if textCount > maximumTextCount {
			characterTextView.isWarning = true
		} else {
			characterTextView.isWarning = false
		}
	}
	
	func calenderButtonDidTap() {
		print("calenderButtonDidTap")
	}
	
	func didNeuterButtonDidTap() {
		if didNeuterButton.buttonIsSelected == true { return }
		
		didNeuterButton.buttonIsSelected.toggle()
		if didNotNeuterButton.buttonIsSelected == true {
			didNotNeuterButton.buttonIsSelected = false
		}
	}
	
	func didNotNeuterButtonDidTap() {
		if didNotNeuterButton.buttonIsSelected == true { return }
		
		didNotNeuterButton.buttonIsSelected.toggle()
		if didNeuterButton.buttonIsSelected == true {
			didNeuterButton.buttonIsSelected = false
		}
	}
	
	@objc func backButtonDidTap() {
		listener?.backButtonDidTap()
	}
}
