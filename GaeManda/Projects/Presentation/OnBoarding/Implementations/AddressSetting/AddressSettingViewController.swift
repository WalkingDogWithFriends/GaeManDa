import CoreLocation
import UIKit
import RIBs
import NMapsMap
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
	private enum Constant {
		static let defaultCameraPosition = NMFCameraPosition( NMGLatLng(lat: 37.5666102, lng: 126.9783881), zoom: 14)
		static let defaultCameraZoomLevel = 18.0
		static let defaultCameraAnimation = NMFCameraUpdateAnimation.easeIn
		static let defaultCameraAnimationDuration = 0.3
	}
	// MARK: - Properties
	weak var listener: AddressSettingPresentableListener?
	
	// MARK: - UI Components
	private let navigationBar = GMDNavigationBar(title: "")
	
	private let onBoardingView = OnBoardingView(title: "사생활 보호를 위해\n집 주소를 입력해주세요!")
	
	private let searchTextField: UnderLineTextField = {
		let underLineTextField = UnderLineTextField()
		underLineTextField.underLineColor = .black
		underLineTextField.placeholder = "도로명 또는 지번 주소를 입력해주세요"
		underLineTextField.leftView = UIImageView(image: .iconSearch)
		underLineTextField.leftViewMode = .always
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
	
	/// 네이버 지도 뷰
	private let mapView: NMFMapView = {
		let mapView = NMFMapView()
		mapView.moveCamera(NMFCameraUpdate(position: Constant.defaultCameraPosition))
		mapView.locationOverlay.hidden = false
		mapView.isUserInteractionEnabled = false
		return mapView
	}()
	
	private let locationManager: CLLocationManager = {
		let locationManager = CLLocationManager()
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		return locationManager
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
		self.locationManager.requestWhenInUseAuthorization()
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
		bindCLLocationManager()
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
				owner.loadLocation()
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
	
	func bindCLLocationManager() {
		locationManager.rx.didUpdateLocations
			.filter { !$0.locations.isEmpty }
			.bind(with: self) { owner, clLocationsEvent in
				clLocationsEvent.manager.stopUpdatingLocation()
				let location = clLocationsEvent.locations.last!.latLng
				let cameraUpdatePosition = NMFCameraUpdate(
					scrollTo: location,
					zoomTo: Constant.defaultCameraZoomLevel,
					cameraAnimation: Constant.defaultCameraAnimation,
					duration: Constant.defaultCameraAnimationDuration
				)
				
				owner.mapView.moveCamera(cameraUpdatePosition)
				owner.mapView.locationOverlay.location = location
			}
			.disposed(by: disposeBag)
		
		locationManager.rx.didChangeAuthorization
			.filter { $0.status == .notDetermined }
			.bind { clLocationEvent in
				clLocationEvent.manager.requestWhenInUseAuthorization()
			}
			.disposed(by: disposeBag)
		
		locationManager.rx.didError
			.bind { clLocationEvent in
				print("error: \(clLocationEvent.error)")
			}
			.disposed(by: disposeBag)
	}
	
	func loadLocation() {
		if locationManager.authorizationStatus == .authorizedAlways ||
				locationManager.authorizationStatus == .authorizedWhenInUse {
			locationManager.startUpdatingLocation()
		} else {
			/// 권한이 없다면 권한이 없다는 알림창을 보여주고, 권한 설정 페이지로 이동합니다.
			let alert = UIAlertController(title: "위치 권한이 없습니다.", message: "위치 권한을 허용해주세요.", preferredStyle: .alert)
			let okAction = UIAlertAction(title: "확인", style: .default) { _ in
				guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
				UIApplication.shared.open(url, options: [:], completionHandler: nil)
			}
			let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
			alert.addAction(okAction)
			alert.addAction(cancelAction)
			present(alert, animated: true, completion: nil)
		}
	}
}

extension AddressSettingViewController: AddressSettingPresentable {
	func setDetailAddress(latitude: Double, longitude: Double) {
		let cameraUpdatePosition = NMFCameraUpdate(
			scrollTo: NMGLatLng(lat: latitude, lng: longitude),
			zoomTo: Constant.defaultCameraZoomLevel,
			cameraAnimation: Constant.defaultCameraAnimation,
			duration: Constant.defaultCameraAnimationDuration
		)
		self.mapView.moveCamera(cameraUpdatePosition)
		self.mapView.locationOverlay.location = .init(lat: latitude, lng: longitude)
	}
}

/// 부드럽게 지도 위치를 이동하기 위한 확장자
fileprivate extension NMFCameraUpdate {
	convenience init(
		scrollTo: NMGLatLng,
		zoomTo: Double,
		cameraAnimation: NMFCameraUpdateAnimation,
		duration: Double
	) {
		self.init(scrollTo: scrollTo, zoomTo: zoomTo)
		animation = cameraAnimation
		animationDuration = duration
	}
}

fileprivate extension CLLocation {
	var latLng: NMGLatLng {
		return NMGLatLng(lat: coordinate.latitude, lng: coordinate.longitude)
	}
}
