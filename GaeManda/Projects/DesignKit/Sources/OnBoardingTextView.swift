import UIKit
import Extensions

public enum RightViewMode {
	case none
	case calendar
	case textCount(maximumTextCount: Int) // raw값 넣고
}

public final class OnBoardingTextView: UIView {
	private let rightViewMode: RightViewMode
	
	public lazy var isWarning = false {
		didSet {
			if isWarning == true {
				changeWarningMode()
			} else {
				changeNormalMode()
			}
		}
	}
	
	private lazy var hasContent = false {
		didSet {
			if hasContent == true {
				titleLabel.layer.opacity = 1.0
			} else {
				titleLabel.layer.opacity = 0.0
			}
		}
	}
	
	private let stackView: UIStackView = {
		let stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.spacing = 7
		stackView.axis = .vertical
		stackView.alignment = .fill
		stackView.distribution = .fillProportionally
		
		return stackView
	}()
	
	private let titleLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .init(hexCode: "979797")
		label.layer.opacity = 0.0
		label.numberOfLines = 1
		label.font = .systemFont(ofSize: 12)
		
		return label
	}()
	
	private let textField: UnderLineTextField = {
		let textField = UnderLineTextField()
		textField.translatesAutoresizingMaskIntoConstraints = false
		textField.font = .systemFont(ofSize: 15)
		
		return textField
	}()
	
	private lazy var warningLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .init(hexCode: "FF0000")
		label.numberOfLines = 1
		label.font = .systemFont(ofSize: 12)
		label.layer.opacity = 0.0
		
		return label
	}()
	
	private lazy var maximumTextCountLabel: UILabel = {
		let label = UILabel()
		label.textColor = .init(hexCode: "979797")
		label.font = .systemFont(ofSize: 12)
		
		return label
	}()
	
	private lazy var maximumTextCount: Int = 0
	
	private lazy var calenderButton: UIButton = {
		let button = UIButton()
		let image = UIImage(systemName: "calendar")
		button.tintColor = .black
		button.setImage(image, for: .normal)
		
		return button
	}()
	
	public init(
		title: String,
		rightViewMode: RightViewMode
	) {
		self.rightViewMode = rightViewMode
		super.init(frame: .zero)
				
		titleLabel.text = title
		textField.placeholder = title
		setupUI()
		
		switch rightViewMode {
		case .calendar:
			displayCalenderButton()
		case .textCount(let maximumTextCount):
			displayMaximunTextCount(maximumTextCount)
		case .none:
			break
		}
	}
	
	public convenience init(
		title: String,
		rightViewMode: RightViewMode,
		warningText: String
	) {
		self.init(title: title, rightViewMode: rightViewMode)
		self.warningLabel.text = warningText
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupUI() {
		addSubview(stackView)
		stackView.addArrangedSubview(titleLabel)
		stackView.addArrangedSubview(textField)
		stackView.addArrangedSubview(warningLabel)
		
		NSLayoutConstraint.activate([
			stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			stackView.topAnchor.constraint(equalTo: self.topAnchor),
			stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
		])
	}
	
	private func displayMaximunTextCount(_ maximumTextCount: Int) {
		textField.rightView = maximumTextCountLabel
		textField.rightViewMode = .always
		self.maximumTextCount = maximumTextCount
		maximumTextCountLabel.text = "0/\(maximumTextCount)"
		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(textDidChange),
			name: UITextField.textDidChangeNotification,
			object: textField
		)
	}
	
	private func displayCalenderButton() {
		textField.rightView = calenderButton
		textField.rightViewMode = .always
	}
}

private extension OnBoardingTextView {
	func changeNormalMode() {
		textField.underLineColor = .black
		warningLabel.layer.opacity = 0.0
	}
	
	func changeWarningMode() {
		textField.underLineColor = .init(hexCode: "FF0000")
		warningLabel.layer.opacity = 1.0
	}
	
	@objc func textDidChange(_ notification: Notification) {
		guard
			let textField = notification.object as? UITextField,
			let text = textField.text
		else {
			return
		}
		var count = text.count
		
		if count == 0 {
			hasContent = false
		} else {
			hasContent = true
		}
		
		if count >= maximumTextCount {
			let index = text.index(text.startIndex, offsetBy: maximumTextCount)
			let newString = text[text.startIndex..<index]
			textField.text = String(newString)
			count = 20
		}
		maximumTextCountLabel.text = "\(count)/\(maximumTextCount)"
	}
}
