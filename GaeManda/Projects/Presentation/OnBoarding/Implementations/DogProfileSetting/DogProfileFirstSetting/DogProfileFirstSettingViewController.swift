import PhotosUI
import UIKit
import RIBs
import RxCocoa
import RxSwift
import SnapKit
import DesignKit
import Entity
import GMDUtils
import GMDExtensions
import OnBoarding

// swiftlint:disable:next type_name
protocol DogProfileFirstSettingPresentableListener: AnyObject {
	func viewDidLoad()
	func didTapConfirmButton(with profileImage: UIImageWrapper)
	func didTapBackButton()
	func dismiss()
}

final class DogProfileFirstSettingViewController:
	BaseViewController,
	DogProfileFirstSettingViewControllable {
	// MARK: - Properties
	weak var listener: DogProfileFirstSettingPresentableListener?
	
	// MARK: - UI Components
	// MARK: - UI Components
	private let navigationBar = GMDNavigationBar(title: "")
	
	private let titleLabel: UILabel = {
		let label = UILabel()
		label.font = .jalnan20
		label.numberOfLines = 0
		label.text = "우리 아이를 등록해주세요! (1/2)"
		
		return label
	}()
	
	private let profileImageView = ProfileImageView(mode: .editable)
	private let confirmButton = ConfirmButton(title: "확인", isPositive: false)
	
	// MARK: - Life Cycles
	override func viewDidLoad() {
		super.viewDidLoad()

		setupUI()
		listener?.viewDidLoad()
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
	
	override func setViewHierarchy() {
		super.setViewHierarchy()
		contentView.addSubviews(navigationBar, titleLabel, profileImageView, confirmButton)
	}
	
	override func setConstraints() {
		super.setConstraints()
		
		navigationBar.snp.makeConstraints { make in
			make.top.leading.trailing.equalToSuperview()
			make.height.equalTo(44)
		}
		
		titleLabel.snp.makeConstraints { make in
			make.top.equalTo(navigationBar.snp.bottom).offset(28)
			make.leading.equalToSuperview().offset(32)
			make.trailing.equalToSuperview().offset(-32)
		}
		
		profileImageView.snp.makeConstraints { make in
			make.top.equalTo(titleLabel.snp.bottom).offset(40)
			make.width.height.equalTo(140)
			make.centerX.equalToSuperview()
		}
		
		confirmButton.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(32)
			make.trailing.equalToSuperview().offset(-32)
			make.bottom.equalToSuperview().offset(-(54 - UIDevice.safeAreaBottomHeight))
			make.height.equalTo(40)
		}
	}
	
	func addDogProfileFirstDashboard(_ viewControllable: ViewControllable) {
		let viewController = viewControllable.uiviewController
		
		addChild(viewController)
		contentView.addSubview(viewController.view)
		
		viewController.view.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(32)
			make.trailing.equalToSuperview().offset(-32)
			make.top.equalTo(profileImageView.snp.bottom).offset(24)
			make.bottom.equalTo(confirmButton.snp.top).offset(-56)
		}
		
		viewController.didMove(toParent: self)
	}
		
	// MARK: - Bind Methods
	override func bind() {
		super.bind()
		bindNavigation()
		bindProfileImageView()
		bindConfirmButton()
	}
	
	private func bindNavigation() {
		navigationBar.backButton.rx.tap
			.bind(with: self) { owner, _ in
				owner.listener?.didTapBackButton()
			}
			.disposed(by: disposeBag)
	}
	
	private func bindProfileImageView() {
		profileImageView.rx.didTapImageView
			.bind(with: self) { owner, _ in
				owner.presentPHPickerView()
			}
			.disposed(by: disposeBag)
	}
	
	private func bindConfirmButton() {
		confirmButton.rx.tap
			.bind(with: self) { owner, _ in
				owner.listener?.didTapConfirmButton(with: .init(owner.profileImageView.image))
			}
			.disposed(by: disposeBag)
	}
}

// MARK: - PHPickerViewControllerDelegate
extension DogProfileFirstSettingViewController: PHPickerViewControllerDelegate {
	func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
		picker.dismiss(animated: true)
		guard let firstResult = results.first else { return }
		firstResult.fetchImage { result in
			switch result {
				case let .success(image):
					self.profileImageView.image = image
				case .failure: break //
			}
		}
	}
}

extension DogProfileFirstSettingViewController: DogProfileFirstSettingPresentable {
	func setConfirmButton(isPositive: Bool) {
		confirmButton.isPositive = isPositive
	}
}
