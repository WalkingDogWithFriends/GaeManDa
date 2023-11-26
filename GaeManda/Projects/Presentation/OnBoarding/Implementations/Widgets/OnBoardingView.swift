import UIKit
import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import DesignKit
import GMDUtils

final class OnBoardingView: UIView {
	// MARK: - UI Components
	private let label: UILabel = {
		let label = UILabel()
		label.font = .jalnan20
		label.numberOfLines = 0
		
		return label
	}()
	
	fileprivate let profileImageView: RoundImageView = {
		let imageView = RoundImageView()
		imageView.backgroundColor = .gray30
		
		return imageView
	}()
	
	// MARK: - Initializers
	init(
		willDisplayImageView: Bool = false,
		title: String
	) {
		self.label.text = title
		super.init(frame: .zero)
		setViewHierarchy(willDisplayImageView)
		setConstraints(willDisplayImageView)
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError()
	}
}

// MARK: - UI Methods
private extension OnBoardingView {
	func setViewHierarchy(_ willDisplayImageView: Bool) {
		addSubview(label)
		if willDisplayImageView {
			addSubview(profileImageView)
		}
	}
	
	func setConstraints(_ willDisplayImageView: Bool) {
		if willDisplayImageView {
			label.snp.makeConstraints { make in
				make.top.leading.trailing.equalToSuperview()
			}
			profileImageView.snp.makeConstraints { make in
				make.top.equalTo(label.snp.bottom).offset(40)
				make.width.height.equalTo(140)
				make.centerX.equalToSuperview()
				make.bottom.equalToSuperview()
			}
		} else {
			label.snp.makeConstraints { make in
				make.edges.equalToSuperview()
			}
		}
	}
}

// MARK: Setter Methods
extension OnBoardingView {
	func setTitleLabel(_ title: String) {
		self.label.attributedText = title.titlelg()
	}
	
	func setProfileImage(_ image: UIImage?) {
		DispatchQueue.main.async {
			self.profileImageView.image = image
		}
	}
}

// MARK: - Reactive Extension
extension Reactive where Base: OnBoardingView {
	// 프로필 이미지 선택 Observable
	var didTapImageView: Observable<Void> {
		return base.profileImageView.rx.tapGesture()
			.when(.recognized)
			.map { _ in }
	}
}
