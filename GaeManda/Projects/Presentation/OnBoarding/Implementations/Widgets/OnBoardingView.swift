import UIKit
import SnapKit
import DesignKit
import GMDUtils

final class OnBoardingView: UIView {
	private let label: UILabel = {
		let label = UILabel()
		label.font = .jalnan20
		label.numberOfLines = 0
		
		return label
	}()
	
	private lazy var profileImageView: RoundImageView = {
		let imageView = RoundImageView()
		imageView.backgroundColor = .gray30
		
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
			label.snp.makeConstraints { make in
				make.leading.equalToSuperview().offset(33)
				make.top.equalToSuperview().offset(119)
			}
			profileImageView.snp.makeConstraints { make in
				make.top.equalTo(label.snp.bottom).offset(48)
				make.height.equalTo(140)
				make.width.equalTo(140)
				make.centerX.equalToSuperview()
				make.bottom.equalToSuperview()
			}
		} else {
			label.snp.makeConstraints { make in
				make.leading.equalToSuperview().offset(33)
				make.top.equalToSuperview().offset(119)
				make.bottom.equalToSuperview()
			}
		}
	}
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
