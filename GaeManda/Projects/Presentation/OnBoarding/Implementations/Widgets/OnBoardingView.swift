import UIKit
import DesignKit
import Utils

final class OnBoardingView: UIView {
	private let label: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = .systemFont(ofSize: 20, weight: .bold)
		label.numberOfLines = 1
		
		return label
	}()
	
	private let profileImageView: RoundImageView = {
		let imageView = RoundImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		
		return imageView
	}()
	
	init() {
		super.init(frame: .zero)
		setupSubViews()
		setConstraints()
	}
	
	convenience init(title: String) {
		self.init()
		self.label.text = title
	}
	
	required init?(coder: NSCoder) {
		fatalError()
	}
	
	private func setupSubViews() {
		addSubview(label)
		addSubview(profileImageView)
	}
	
	private func setConstraints() {
		NSLayoutConstraint.activate([
			label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 31.5),
			label.topAnchor.constraint(equalTo: topAnchor, constant: 128),
			
			profileImageView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 40),
			profileImageView.heightAnchor.constraint(equalToConstant: 140),
			profileImageView.widthAnchor.constraint(equalToConstant: 140),
			profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
			profileImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
		])
	}
}

extension OnBoardingView {
	func setTitleLabel(_ title: String) {
		self.label.text = title
	}
	
	func setProfileImage(_ image: UIImage?) {
		self.profileImageView.image = image
	}
}
