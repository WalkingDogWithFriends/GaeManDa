import UIKit
import RIBs
import RxCocoa
import RxSwift
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
		underLineTextField.placeholder = "도로명 또는 지번 주소를 입력해주세요"
		let image = UIImage(systemName: "magnifyingglass")
		underLineTextField.setLeftImage(image, size: 24)
		
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
		titleAttribute.font = .boldSystemFont(ofSize: 12)
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
		label.font = .systemFont(ofSize: 14)
		label.numberOfLines = 0
		label.adaptFontSpecificText(text, specificText: "반경 500M")
		
		return label
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
		NSLayoutConstraint.activate([
			onBoardingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			onBoardingView.topAnchor.constraint(equalTo: view.topAnchor),
			
			searchTextField.topAnchor.constraint(equalTo: onBoardingView.bottomAnchor, constant: 61),
			searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
			searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
			
			loadLocationButton.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 30),
			loadLocationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
			loadLocationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
			loadLocationButton.heightAnchor.constraint(equalToConstant: 28),
			
			mapView.topAnchor.constraint(equalTo: loadLocationButton.bottomAnchor, constant: 10),
			mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
			mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
			mapView.heightAnchor.constraint(equalToConstant: 237),
			
			noticeLabel.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 20),
			noticeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
			noticeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
			
			confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
			confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
			confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -45),
			confirmButton.heightAnchor.constraint(equalToConstant: 40)
		])
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
