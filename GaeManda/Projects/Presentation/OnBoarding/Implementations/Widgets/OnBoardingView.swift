import UIKit
import DesignKit
import GMDUtils

final class OnBoardingView: UIView {
	private let label: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = .jalnan20
		label.numberOfLines = 0
		
		return label
	}()
	
	private lazy var profileImageView: RoundImageView = {
		let imageView = RoundImageView()
		imageView.backgroundColor = .gray30
		imageView.translatesAutoresizingMaskIntoConstraints = false
		
		return imageView
	}()
	
	init(willDisplayImageView: Bool) {
		super.init(frame: .zero)
		setupSubViews(willDisplayImageView)
		setConstraints(willDisplayImageView)
	}
	
	convenience init(
		willDisplayImageView: Bool,
		title: String
	) {
		self.init(willDisplayImageView: willDisplayImageView)
		self.label.text = title
	}
	
	required init?(coder: NSCoder) {
		fatalError()
	}
	
	private func setupSubViews(_ willDisplayImageView: Bool) {
		addSubview(label)
		if willDisplayImageView {
			addSubview(profileImageView)
		}
	}
	
	private func setConstraints(_ willDisplayImageView: Bool) {
		if willDisplayImageView {
			NSLayoutConstraint.activate(constraintLabelAndImageView)
		} else {
			NSLayoutConstraint.activate(constraintLabel)
		}
	}
	
	// MARK: Constriants
	lazy var constraintLabel = [
		label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 33),
		label.topAnchor.constraint(equalTo: topAnchor, constant: 119),
		label.bottomAnchor.constraint(equalTo: bottomAnchor)
	]
	lazy var constraintLabelAndImageView = [
		label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 33),
		label.topAnchor.constraint(equalTo: topAnchor, constant: 119),
		profileImageView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 48),
		profileImageView.heightAnchor.constraint(equalToConstant: 140),
		profileImageView.widthAnchor.constraint(equalToConstant: 140),
		profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
		profileImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
	]
}

// MARK: setter
extension OnBoardingView {
	func setTitleLabel(_ title: String) {
		self.label.text = title
	}
	
	func setProfileImage(_ image: UIImage?) {
		self.profileImageView.image = image
	}
}
