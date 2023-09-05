import UIKit
import RIBs
import RxCocoa
import RxSwift
import SnapKit
import DesignKit
import Entity
import GMDExtensions
import GMDUtils

protocol ThirdDogSettingPresentableListener: AnyObject {
	func confirmButtonDidTap()
	func backButtonDidTap()
}

final class ThirdDogSettingViewController:
	BaseViewController,
	ThirdDogSettingPresentable,
	ThirdDogSettingViewControllable {
	// MARK: - Properties
	weak var listener: ThirdDogSettingPresentableListener?
	private let maximumTextCount: Int = 100
	
	// MARK: - UI Components
	private let navigationBar = GMDNavigationBar(title: "")
	
	private let onBoardingView = OnBoardingView(willDisplayImageView: true, title: "우리 아이를 등록해주세요! (3/3)")
	
	private let buttonStackViewLabel: UILabel = {
		let label = UILabel()
		label.text = "중성화"
		label.font = .r12
		label.textColor = .gray90
		
		return label
	}()
	
	private let buttonStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .horizontal
		stackView.alignment = .fill
		stackView.spacing = 26
		stackView.distribution = .fillEqually
		
		return stackView
	}()
	
	private let didNeuterButton: GMDOptionButton = {
		let button = GMDOptionButton(title: "했어요")
		button.isSelected = true
		
		return button
	}()
	
	private let didNotNeuterButton = GMDOptionButton(title: "안 했어요")
	
	private let characterTextView = GMDTextView(title: "우리 아이 성격 (선택)")
	
	private let confirmButton = ConfirmButton(title: "확인")
	
	// MARK: - Life Cycles
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
	}
	
	// MARK: - UI Methods
	private func setupUI() {
		setViewHierarchy()
		setConstraints()
		bind()
	}
	
	override func setViewHierarchy() {
		super.setViewHierarchy()
		contentView.addSubviews(
			navigationBar, onBoardingView, buttonStackViewLabel, buttonStackView, characterTextView, confirmButton
		)
		buttonStackView.addArrangedSubviews(didNeuterButton, didNotNeuterButton)
	}
	
	override func setConstraints() {
		super.setConstraints()
		navigationBar.snp.makeConstraints { make in
			make.top.leading.trailing.equalToSuperview()
			make.height.equalTo(44)
		}
		
		onBoardingView.snp.makeConstraints { make in
			make.top.equalTo(navigationBar.snp.bottom).offset(28)
			make.leading.equalToSuperview().offset(32)
			make.trailing.equalToSuperview().offset(-32)
		}
		
		buttonStackViewLabel.snp.makeConstraints { make in
			make.top.equalTo(onBoardingView.snp.bottom).offset(48)
			make.leading.equalToSuperview().offset(32)
			make.trailing.equalToSuperview().offset(-32)
		}
		
		buttonStackView.snp.makeConstraints { make in
			make.top.equalTo(buttonStackViewLabel.snp.bottom).offset(8)
			make.leading.equalToSuperview().offset(32)
			make.trailing.equalToSuperview().offset(-32)
			make.height.equalTo(40)
		}
		
		characterTextView.snp.makeConstraints { make in
			make.top.equalTo(buttonStackView.snp.bottom).offset(44)
			make.leading.equalToSuperview().offset(32)
			make.trailing.equalToSuperview().offset(-32)
		}
		
		confirmButton.snp.makeConstraints { make in
			make.top.equalTo(characterTextView.snp.bottom).offset(98)
			make.leading.equalToSuperview().offset(32)
			make.trailing.equalToSuperview().offset(-32)
			make.bottom.equalToSuperview().offset(-(54 - UIDevice.safeAreaBottomHeight))
			make.height.equalTo(40)
		}
	}
	
	// MARK: - UI Binding
	override func bind() {
		super.bind()
		bindNavigationBar()
		bindNeuterButon()
		bindCharacterTextView()
		bindConfirmButton()
	}
	
	private func bindNavigationBar() {
		navigationBar.backButton.rx.tap
			.bind(with: self) { owner, _ in
				owner.listener?.backButtonDidTap()
			}
			.disposed(by: disposeBag)
	}
	private func bindNeuterButon() {
		// 중성화 버튼 선택 Observable
		let selectedNeuterButon = Observable
			.merge(
				didNeuterButton.rx.tap.map { Neutered.true },
				didNotNeuterButton.rx.tap.map { Neutered.false }
			)
			.asDriver(onErrorJustReturn: .true)
		
		// 중성화 한 경우
		selectedNeuterButon
			.map { $0 == .true }
			.drive(didNeuterButton.rx.isSelected)
			.disposed(by: disposeBag)
		
		// 중성화 하지 않은 경우
		selectedNeuterButon
			.map { $0 == .false }
			.drive(didNotNeuterButton.rx.isSelected)
			.disposed(by: disposeBag)
	}
	
	private func bindCharacterTextView() {
		characterTextView.textView.rx.didBeginEditing
			.bind(with: self) { owner, _ in
				owner.characterTextView.textView.becomeFirstResponder()
			}
			.disposed(by: disposeBag)
		
		characterTextView.textView.rx.text.orEmpty
			.withUnretained(self)
			.map { owner, text in
				"\(text.count)/\(owner.maximumTextCount)"
			}
			.bind(to: characterTextView.maximumTextCountLabel.rx.text)
			.disposed(by: disposeBag)
		
		characterTextView.textView.rx.text.orEmpty
			.withUnretained(self)
			.map { owner, text in
				return text.count > owner.maximumTextCount
			}
			.bind(to: characterTextView.rx.isWarning)
			.disposed(by: disposeBag)
	}
	
	private func bindConfirmButton() {
		confirmButton.rx.tap
			.withLatestFrom(characterTextView.textView.rx.text.orEmpty) { [weak self] _, text in
				guard let self else { return false }
				return text.count <= self.maximumTextCount
			}
			.filter { $0 == true }
			.bind(with: self) { owner, _ in
				owner.listener?.confirmButtonDidTap()
			}
			.disposed(by: disposeBag)
	}
}

// MARK: - Action
private extension ThirdDogSettingViewController {
	func calenderButtonDidTap() {
		print("calenderButtonDidTap")
	}
}
