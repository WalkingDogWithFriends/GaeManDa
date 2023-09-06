import UIKit
import RxCocoa
import RxSwift
import SnapKit
import GMDExtensions

public enum GMDTextFieldMode {
	case warning
	case normal
}

public final class GMDTextField: UIView {
	// MARK: - Properties
	public var mode: GMDTextFieldMode = .normal {
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
			textField.text ?? ""
		}
		set {
			textField.text = newValue
		}
	}
	
	public var attributedText: NSAttributedString {
		get {
			textField.attributedText ?? NSAttributedString(string: "")
		}
		set {
			textField.attributedText = newValue
		}
	}
	
	public var titleAlpha: CGFloat {
		get {
			titleLabel.alpha
		}
		set {
			titleLabel.alpha = newValue
		}
	}
	
	// MARK: - UI Components
	private let stackView: UIStackView = {
		let stackView = UIStackView()
		stackView.spacing = 7
		stackView.axis = .vertical
		stackView.alignment = .fill
		stackView.distribution = .fillProportionally
		
		return stackView
	}()
	
	public let titleLabel: UILabel = {
		let label = UILabel()
		label.textColor = .gray90
		label.numberOfLines = 1
		label.font = .r12
		label.alpha = 0
		
		return label
	}()
	
	public let textField: UnderLineTextField = {
		let textField = UnderLineTextField()
		textField.font = .r15
		textField.underLineColor = .gray90
		
		return textField
	}()
	
	private let warningLabel: UILabel = {
		let label = UILabel()
		label.textColor = .red100
		label.numberOfLines = 1
		label.font = .r12
		label.layer.opacity = 0.0
		
		return label
	}()
	
	// MARK: - Initializers
	public init(title: String) {
		super.init(frame: .zero)
		
		titleLabel.text = title
		textField.placeholder = title
		setupUI()
	}
	
	public convenience init(
		title: String,
		warningText: String
	) {
		self.init(title: title)
		self.warningLabel.text = warningText
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError()
	}
}

// MARK: - UI Setting
private extension GMDTextField {
	func setupUI() {
		textField.setPlaceholdColor(.gray90)
		
		setViewHierarchy()
		setConstraints()
	}
	
	func setViewHierarchy() {
		addSubview(stackView)
		stackView.addArrangedSubviews(titleLabel, textField, warningLabel)
	}
	
	func setConstraints() {
		stackView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
	}
}

// MARK: - UI Logic
private extension GMDTextField {
	func changeNormalMode() {
		textField.underLineColor = .gray90
		warningLabel.layer.opacity = 0.0
	}
	
	func changeWarningMode() {
		textField.underLineColor = .red100
		warningLabel.layer.opacity = 1.0
	}
}

// MARK: - Reactive Extension
public extension Reactive where Base: GMDTextField {
	var text: ControlProperty<String?> {
		base.textField.rx.text
	}
	
	var attributedText: ControlProperty<NSAttributedString?> {
		base.textField.rx.attributedText
	}
}
