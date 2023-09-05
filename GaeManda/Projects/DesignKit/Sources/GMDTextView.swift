import UIKit
import RxCocoa
import RxSwift
import SnapKit
import GMDExtensions

public enum GMDTextViewMode {
	case warning
	case normal
}

public final class GMDTextView: UIView {
	// MARK: - Properties
	public var mode: GMDTextViewMode = .normal {
		didSet {
			switch mode {
			case .normal:
				changeNormalMode()
			case .warning:
				changeWarningMode()
			}
		}
	}
	
	public var text: String {
		get {
			textView.text ?? ""
		}
		set {
			textView.text = newValue
//			textView.refreshControl?.sendActions(for: .valueChanged)
		}
	}
	
	/// 최대 TextCount를 설정합니다.
	public private(set) var maxTextCount: Int
		
	// MARK: - UI Components
	private let stackView: UIStackView = {
		let stackView = UIStackView()
		stackView.spacing = 8
		stackView.axis = .vertical
		stackView.alignment = .fill
		stackView.distribution = .fillProportionally
		
		return stackView
	}()
	
	private let labelStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .horizontal
		stackView.alignment = .fill
		stackView.distribution = .fillEqually
		
		return stackView
	}()
	
	private let titleLabel: UILabel = {
		let label = UILabel()
		label.textColor = .gray90
		label.numberOfLines = 1
		label.font = .r12
		
		return label
	}()
	
	public let maximumTextCountLabel: UILabel = {
		let label = UILabel()
		label.textColor = .gray90
		label.numberOfLines = 1
		label.font = .r12
		label.textAlignment = .right
		
		return label
	}()
	
	public let textView: UITextView = {
		let textView = UITextView()
		textView.layer.borderColor = UIColor.gray90.cgColor
		textView.layer.borderWidth = 1.5
		textView.layer.cornerRadius = 4
		textView.font = .r12
		
		return textView
	}()
	
	public let warningLabel: UILabel = {
		let label = UILabel()
		label.textColor = .red100
		label.numberOfLines = 1
		label.font = .r12
		label.layer.opacity = 0.0
		
		return label
	}()
	
	// MARK: - Initializer
	public init(
		title: String,
		maxTextCount: Int = 100
	) {
		self.maxTextCount = maxTextCount
		super.init(frame: .zero)
		
		titleLabel.text = title
		warningLabel.text = "\(maxTextCount)자 이내로 입력 가능합니다."
		setupUI()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: - UI Settings
private extension GMDTextView {
	func setupUI() {
		setViewHierarchy()
		setConstraints()
	}
	
	func setViewHierarchy() {
		addSubviews(labelStackView, textView, warningLabel)
		labelStackView.addArrangedSubviews(titleLabel, maximumTextCountLabel)
	}
	
	func setConstraints() {
		labelStackView.snp.makeConstraints { make in
			make.top.leading.trailing.equalToSuperview()
		}
		
		textView.snp.makeConstraints { make in
			make.top.equalTo(labelStackView.snp.bottom).offset(8)
			make.leading.trailing.equalToSuperview()
			make.height.equalTo(128)
		}
		
		warningLabel.snp.makeConstraints { make in
			make.top.equalTo(textView.snp.bottom)
			make.leading.trailing.bottom.equalToSuperview()
		}
	}
}

private extension GMDTextView {
	func changeNormalMode() {
		textView.layer.borderColor = UIColor.gray90.cgColor
		warningLabel.layer.opacity = 0.0
	}
	
	func changeWarningMode() {
		textView.layer.borderColor = UIColor.red100.cgColor
		warningLabel.layer.opacity = 1.0
	}
}

// MARK: - Reactive Extension
public extension Reactive where Base: GMDTextView {
	var text: ControlProperty<String?> {
		base.textView.rx.text
	}
}
