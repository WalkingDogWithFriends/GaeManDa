import UIKit
import RIBs
import RxCocoa
import RxSwift
import Utils

protocol AddressSettingPresentableListener: AnyObject {
	func confirmButtonDidTap()
	func backButtonDidTap()
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
		view.addSubview(confirmButton)
	}
	
	private func setConstraints() {
		NSLayoutConstraint.activate([
			onBoardingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			onBoardingView.topAnchor.constraint(equalTo: view.topAnchor),
			
			confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
			confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
			confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -45),
			confirmButton.heightAnchor.constraint(equalToConstant: 40)
		])
	}
	
	private func bind() {
		confirmButton.rx.tap
			.bind { [weak self] _ in
				self?.listener?.confirmButtonDidTap()
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
