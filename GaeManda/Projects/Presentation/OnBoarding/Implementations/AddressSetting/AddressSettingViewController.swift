import UIKit
import RIBs
import Utils

protocol AddressSettingPresentableListener: AnyObject {
	func confirmButtonDidTap()
}

final class AddressSettingViewController:
	UIViewController,
	AddressSettingPresentable,
	AddressSettingViewControllable {
	weak var listener: AddressSettingPresentableListener?
	
	private lazy var confirmButton: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setTitle("확인", for: .normal)
		button.setTitleColor(.white, for: .normal)
		button.layer.cornerRadius = 4
		button.backgroundColor = .init(hexCode: "65BF4D")
		button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
		button.addTarget(
			self,
			action: #selector(confirmButtonDidTap),
			for: .touchUpInside
		)
		
		return button
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
	}
	
	private func setupUI() {
		self.view.backgroundColor = .white
		setupSubviews()
		setConstraints()
	}
	
	private func setupSubviews() {
		self.view.addSubview(confirmButton)
	}
	
	private func setConstraints() {
		NSLayoutConstraint.activate([
			confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
			confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
			confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -45),
			confirmButton.heightAnchor.constraint(equalToConstant: 40)
		])
	}
}

// MARK: Action
private extension AddressSettingViewController {
	@objc func confirmButtonDidTap() {
		listener?.confirmButtonDidTap()
	}
}
