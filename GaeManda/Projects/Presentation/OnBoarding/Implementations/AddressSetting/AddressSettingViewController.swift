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
	func searchTextFieldDidTap()
	func loadLocationButtonDidTap()
}

final class AddressSettingViewController:
	UIViewController,
	AddressSettingPresentable,
	AddressSettingViewControllable {
	weak var listener: AddressSettingPresentableListener?
	private let disposeBag = DisposeBag()
	
	private let onBoardingView: OnBoardingView = {
		let onBoardingView = OnBoardingView(
			willDisplayImageView: false,
			title: "사생활 보호를 위해\n집 주소를 입력해주세요!"
		)
		onBoardingView.translatesAutoresizingMaskIntoConstraints = false
		
		return onBoardingView
	}()
	
	private let searchTextField: UnderLineTextField = {
		let underLineTextField = UnderLineTextField()
		underLineTextField.translatesAutoresizingMaskIntoConstraints = false
		underLineTextField.underLineColor = .black
		underLineTextField.placeholder = "도로명 또는 지번 주소를 입력해주세요"
		let image = UIImage(systemName: "magnifyingglass")
		underLineTextField.setLeftImage(image, size: 24)
		underLineTextField.setPlaceholdColor(.gray90)
		
		return underLineTextField
	}()
	
	private let loadLocationButton: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		
		var configuration = UIButton.Configuration.plain()
		
		let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 12, weight: .light)
		let image = UIImage(
			systemName: "location.north.circle.fill",
			withConfiguration: imageConfiguration
		)
		configuration.image = image
		configuration.imagePadding = 10
		
		var titleAttribute = AttributedString.init("현재 위치 불러오기")
		titleAttribute.font = .b12
		configuration.attributedTitle = titleAttribute
		
		configuration.contentInsets = NSDirectionalEdgeInsets(
			top: 4,
			leading: 0,
			bottom: 4,
			trailing: 0
		)
		configuration.background.backgroundColor = .black
		
		button.configuration = configuration
		button.tintColor = .white
		button.layer.cornerRadius = 4
		
		return button
	}()
	
	private let mapView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = .gray
		view.layer.cornerRadius = 24
		
		return view
	}()
	
	private let noticeLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.tintColor = .black
		let text = "사생활 보호를 위해 등록된 주소에서 반경 500M 내에는 보호자의 위치가 노출되지 않습니다.\n주소를 비롯한 보호자의 개인정보는 타인에게 공유되지 않으니 안심하고 서비스를 이용해주세요."
		label.font = .r12
		label.numberOfLines = 0
		label.adaptFontSpecificText(text, specificText: "반경 500M", font: .b12)
		
		return label
	}()
	
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
		view.addSubview(searchTextField)
		view.addSubview(loadLocationButton)
		view.addSubview(mapView)
		view.addSubview(noticeLabel)
		view.addSubview(confirmButton)
	}
	
	private func setConstraints() {
		onBoardingView.snp.makeConstraints { make in
			make.leading.equalToSuperview()
			make.top.equalToSuperview()
		}
		
		searchTextField.snp.makeConstraints { make in
			make.top.equalTo(onBoardingView.snp.bottom).offset(61)
			make.leading.equalToSuperview().offset(32)
			make.trailing.equalToSuperview().offset(-32)
		}
		
		loadLocationButton.snp.makeConstraints { make in
			make.top.equalTo(searchTextField.snp.bottom).offset(35)
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
			make.leading.equalToSuperview().offset(32)
			make.trailing.equalToSuperview().offset(-32)
			make.bottom.equalToSuperview().offset(-54)
			make.height.equalTo(40)
		}
	}
	
	private func bind() {
		searchTextField.rx.controlEvent(.editingDidBegin)
			.withUnretained(self)
			.bind { owner, _ in
				owner.searchTextField.endEditing(true)
			}
			.disposed(by: disposeBag)
		
		searchTextField.rx.controlEvent(.touchDown)
			.withUnretained(self)
			.bind { owner, _ in
				owner.listener?.searchTextFieldDidTap()
			}
			.disposed(by: disposeBag)
		
		loadLocationButton.rx.tap
			.withUnretained(self)
			.bind { owner, _ in
				owner.listener?.loadLocationButtonDidTap()
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

// MARK: Action
private extension AddressSettingViewController {
	@objc func backButtonDidTap() {
		listener?.backButtonDidTap()
	}
}
