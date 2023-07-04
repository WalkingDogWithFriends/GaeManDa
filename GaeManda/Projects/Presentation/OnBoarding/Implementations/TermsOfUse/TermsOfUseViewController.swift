import UIKit
import RIBs
import RxCocoa
import RxSwift
import Utils

protocol TermsOfUsePresentableListener: AnyObject {
	func confirmButtonDidTap()
}

final class TermsOfUseViewController:
	UIViewController,
	TermsOfUsePresentable,
	TermsOfUseViewControllable {
	weak var listener: TermsOfUsePresentableListener?
	private let disposeBag = DisposeBag()
	
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
		self.view.backgroundColor = .white
		setupSubviews()
		setConstraints()
		bind()
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
	
	private func bind() {
		confirmButton.rx.tap
			.bind { [weak self] _ in
				self?.listener?.confirmButtonDidTap()
			}
	}
}

// MARK: - Action
extension TermsOfUseViewController {
	@objc func confirmButtonDidTap() {
		listener?.confirmButtonDidTap()
	}
}
