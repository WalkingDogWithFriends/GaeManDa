import UIKit
import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import DesignKit
import GMDUtils

final class OnBoardingView: UIView {
	enum OnBoardingViewMode {
		/// Label만 있는 경우
		case `default`
		/// Label과 수정 가능한 이미지 뷰
		case editableImageView
		/// Label과 수정 불가능한 이미지 뷰
		case unEditableImageView
	}
	
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
		viewMode: OnBoardingViewMode,
		title: String
	) {
		self.label.text = title
		super.init(frame: .zero)
		setupUI(with: viewMode)
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError()
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

// MARK: - UI Methods
private extension OnBoardingView {
	func setupUI(with viewMode: OnBoardingViewMode) {
		switch viewMode {
			case .default:
				defaultModeSetViewHeirarchy()
				defaultModeSetConstraints()
				
			case .editableImageView:
				imageViewModeSetViewHeirarchy()
				imageViewModeSetConstraints()
				setupPlusButtonUI()
				
			case .unEditableImageView:
				imageViewModeSetViewHeirarchy()
				imageViewModeSetConstraints()
		}
	}
}

// MARK: - Default Mode UI Methods
private extension OnBoardingView {
	func defaultModeSetViewHeirarchy() {
		addSubviews(label)
	}
	
	func defaultModeSetConstraints() {
		label.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
	}
}

// MARK: - UnEditableImageView / EditableImageView Mode UI Methods
private extension OnBoardingView {
	func imageViewModeSetViewHeirarchy() {
		addSubviews(label)
		addSubviews(profileImageView)
	}
	
	func imageViewModeSetConstraints() {
		label.snp.makeConstraints { make in
			make.top.leading.trailing.equalToSuperview()
		}
		profileImageView.snp.makeConstraints { make in
			make.top.equalTo(label.snp.bottom).offset(40)
			make.width.height.equalTo(140)
			make.centerX.equalToSuperview()
			make.bottom.equalToSuperview()
		}
	}
	
	func setupPlusButtonUI() {
		let imageView = RoundImageView(image: .iconPlusCircleFill)
		imageView.clipsToBounds = true
		
		addSubviews(imageView)
		
		imageView.snp.makeConstraints { make in
			make.width.height.equalTo(32)
			make.trailing.equalTo(profileImageView).offset(-12)
			make.bottom.equalTo(profileImageView).offset(-4)
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
