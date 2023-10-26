import UIKit
import RIBs
import RxCocoa
import RxSwift
import SnapKit
import DesignKit
import GMDExtensions
import GMDUtils

protocol AddressSettingPresentableListener: AnyObject {
	func confirmButtonDidTap()
	func backButtonDidTap()
	func dismiss()
	func searchTextFieldDidTap()
	func loadLocationButtonDidTap()
}

final class AddressSettingViewController:
	BaseViewController,
	AddressSettingViewControllable {
	// MARK: - Properties
	weak var listener: AddressSettingPresentableListener?
	
	// MARK: - UI Components
	private let navigationBar = GMDNavigationBar(title: "")
	
	private let onBoardingView = OnBoardingView(title: "사생활 보호를 위해\n집 주소를 입력해주세요!")
	
	private let searchTextField: UnderLineTextField = {
		let underLineTextField = UnderLineTextField()
		underLineTextField.underLineColor = .black
		underLineTextField.placeholder = "도로명 또는 지번 주소를 입력해주세요"
		underLineTextField.setLeftImage(.iconSearch, size: 24)
		underLineTextField.setPlaceholdColor(.gray90)
		
		return underLineTextField
	}()
	
	private let buttonConfiguration: UIButton.Configuration = {
		var configuration = UIButton.Configuration.plain()
		configuration.image = UIImage.iconGps.withTintColor(.gmdWhite)
		configuration.imagePadding = 12
		configuration.attributedTitle = AttributedString("현재 위치 불러오기".attributedString(font: .b12, color: .white))
		configuration.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0)
		configuration.background.backgroundColor = .black
		
		return configuration
	}()
	
	private lazy var loadLocationButton: UIButton = {
		let button = UIButton()
		button.configuration = self.buttonConfiguration
		button.tintColor = .white
		button.layer.cornerRadius = 4
		
		return button
	}()
	
	private let mapView: UIView = {
		let view = UIView()
		view.backgroundColor = .gray
		view.layer.cornerRadius = 24
		
		return view
	}()
	
	private let noticeLabel: UILabel = {
		let label = UILabel()
		let text =
 """
 사생활 보호를 위해 등록된 주소에서 반경 500M 내에는
 보호자의 위치가 노출되지 않습니다.
 주소를 비롯한 보호자의 개인정보는 타인에게 공유되지
 않으니 안심하고 서비스를 이용해주세요.
 """
		
		label.numberOfLines = 0
		label.lineBreakMode = .byWordWrapping
		label.attributedText = text.attributedString(font: .r12, color: .black, lineSpacing: 12, lineHeightMultiple: 0.73)
		return label
	}()
	
	private let confirmButton = ConfirmButton(title: "확인")
	
	// MARK: - Life Cycles
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		
		if isBeingDismissed || isMovingFromParent {
			listener?.dismiss()
		}
	}
	
	// MARK: - UI Methods
	private func setupUI() {
		setViewHierarchy()
		setConstraints()
		bind()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
	}
	
	override func setViewHierarchy() {
		super.setViewHierarchy()
		contentView.addSubviews(
			navigationBar, onBoardingView, searchTextField, loadLocationButton, mapView, noticeLabel, confirmButton
		)
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
		
		searchTextField.snp.makeConstraints { make in
			make.top.equalTo(onBoardingView.snp.bottom).offset(36)
			make.leading.equalToSuperview().offset(32)
			make.trailing.equalToSuperview().offset(-32)
		}
		
		loadLocationButton.snp.makeConstraints { make in
			make.top.equalTo(searchTextField.snp.bottom).offset(12)
			make.leading.equalToSuperview().offset(32)
			make.trailing.equalToSuperview().offset(-32)
			make.height.equalTo(28)
		}
		
		mapView.snp.makeConstraints { make in
			make.top.equalTo(loadLocationButton.snp.bottom).offset(52)
			make.leading.equalToSuperview().offset(32)
			make.trailing.equalToSuperview().offset(-32)
			make.height.equalTo(235)
		}
		
		noticeLabel.snp.makeConstraints { make in
			make.top.equalTo(mapView.snp.bottom).offset(28)
			make.leading.equalToSuperview().offset(32)
			make.trailing.equalToSuperview().offset(-32)
		}
		
		confirmButton.snp.makeConstraints { make in
			make.top.equalTo(noticeLabel.snp.bottom).offset(52)
			make.leading.equalToSuperview().offset(32)
			make.trailing.equalToSuperview().offset(-32)
			make.bottom.equalToSuperview().offset(-(54 - UIDevice.safeAreaBottomHeight))
			make.height.equalTo(40)
		}
	}
	
	override func bind() {
		super.bind()
		searchTextField.rx.controlEvent(.editingDidBegin)
			.withUnretained(self)
			.do(onNext: { owner, _ in
				if owner.searchTextField.canBecomeFirstResponder {
					owner.searchTextField.resignFirstResponder()
				}
			})
			.bind(onNext: { owner, _ in
				owner.listener?.searchTextFieldDidTap()
			})
			.disposed(by: disposeBag)
		
		loadLocationButton.rx.tap
			.bind(with: self) { owner, _ in
				owner.listener?.loadLocationButtonDidTap()
			}
			.disposed(by: disposeBag)
		
		confirmButton.rx.tap
			.bind(with: self) { owner, _ in
				owner.listener?.confirmButtonDidTap()
			}
			.disposed(by: disposeBag)
		
		navigationBar.backButton.rx.tap
			.bind(with: self) { owner, _ in
				owner.listener?.backButtonDidTap()
			}
			.disposed(by: disposeBag)
	}
}

extension AddressSettingViewController: AddressSettingPresentable {
    func setDetailAddress(_ address: String) {
        self.searchTextField.text = address
    }
}
