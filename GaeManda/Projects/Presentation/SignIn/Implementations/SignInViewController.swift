import UIKit
import RIBs
import RxCocoa
import RxSwift
import SnapKit
import DesignKit
import GMDExtensions

protocol SignInPresentableListener: AnyObject {
	func didTapAppleLoginButton()
	func didTapKakaoLoginButton()
}

final class SignInViewController:
	UIViewController,
	SignInPresentable,
	SignInViewControllable {
	// MARK: - Properties
	weak var listener: SignInPresentableListener?
	private let disposeBag = DisposeBag()
	
	// MARK: - UI Components
	private let stackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.distribution = .fillEqually
		stackView.alignment = .fill
		stackView.spacing = 16
		
		return stackView
	}()
	
	private let appleLoginButton: UIButton = {
		let button = UIButton()
		button.setTitle("Apple", for: .normal)
		button.setTitleColor(.white, for: .normal)
		button.backgroundColor = .black
		button.layer.cornerRadius = 4
		
		return button
	}()
	
	private let kakaoLoginButton: UIButton = {
		let button = UIButton()
		button.setImage(.kakaoLogin, for: .normal)
		return button
	}()
	
	// MARK: - Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
	}
}

// MARK: - UI Setting
private extension SignInViewController {
	func setupUI() {
		view.backgroundColor = .white
		setViewHierarchy()
		setConstraints()
		bind()
	}
	
	func setViewHierarchy() {
		view.addSubview(stackView)
		stackView.addArrangedSubviews(appleLoginButton, kakaoLoginButton)
	}
	
	func setConstraints() {
		stackView.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(32)
			make.trailing.equalToSuperview().offset(-32)
			make.bottom.equalToSuperview().offset(-104)
		}
		
		appleLoginButton.snp.makeConstraints { make in
			make.height.equalTo(44)
		}
		
		kakaoLoginButton.snp.makeConstraints { make in
			make.height.equalTo(44)
		}
	}
}

// MARK: - Action Bind
extension SignInViewController {
	func bind() {
		appleLoginButton.rx.tap
			.bind(with: self) { owner, _ in
				owner.listener?.didTapAppleLoginButton()
			}
			.disposed(by: disposeBag)
		
		kakaoLoginButton.rx.tap
			.bind(with: self) { owner, _ in
				owner.listener?.didTapKakaoLoginButton()
			}
			.disposed(by: disposeBag)
	}
}
