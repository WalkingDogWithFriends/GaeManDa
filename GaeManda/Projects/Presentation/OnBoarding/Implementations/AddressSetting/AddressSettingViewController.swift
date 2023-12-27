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
	
	private let onBoardingView = OnBoardingView(viewMode: .default, title: "사생활 보호를 위해\n집 주소를 입력해주세요!")
	
	private let locationSearchButton = LocationSearchButton()
	
	private let loadLocationButton = LocationLoadButton()
	
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
	
	private let noticeLabel = NoticeLabel()
	
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
			navigationBar, onBoardingView, locationSearchButton, loadLocationButton, mapView, noticeLabel, confirmButton
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
		
		locationSearchButton.snp.makeConstraints { make in
			make.top.equalTo(onBoardingView.snp.bottom).offset(36)
			make.leading.equalToSuperview().offset(32)
			make.trailing.equalToSuperview().offset(-32)
		}
		
		loadLocationButton.snp.makeConstraints { make in
			make.top.equalTo(locationSearchButton.snp.bottom).offset(12)
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
		
		locationSearchButton.rx.tap
			.bind(with: self) { owner, _ in
				owner.listener?.searchTextFieldDidTap()
			}
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
				debugPrint("error: \(clLocationEvent.error)")
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
