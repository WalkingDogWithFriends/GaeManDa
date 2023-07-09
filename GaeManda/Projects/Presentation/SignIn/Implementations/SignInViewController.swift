import UIKit
import RIBs

protocol SignInPresentableListener: AnyObject {
	func appleLoginButtonDidTapped()
	func kakaoLoginButtonDidTapped()
}

final class SignInViewController:
	UIViewController,
	SignInPresentable,
	SignInViewControllable {
	weak var listener: SignInPresentableListener?
	
	private lazy var appleLoginButton: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setTitle("Apple", for: .normal)
		button.tintColor = .black
		button.addTarget(self, action: #selector(appleLoginButtonTapped), for: .touchUpInside)
		
		return button
	}()
	
	private lazy var kakaoLoginButton: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setTitle("Kakao", for: .normal)
		button.tintColor = .black
		button.addTarget(self, action: #selector(kakaoLoginButtonTapped), for: .touchUpInside)
		
		return button
	}()
	
	@objc func appleLoginButtonTapped() {
		listener?.appleLoginButtonDidTapped()
	}
	@objc func kakaoLoginButtonTapped() {
		listener?.kakaoLoginButtonDidTapped()
	}
}
