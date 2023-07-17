import UIKit
import GMDExtensions

public final class OnBoardingTextField: UIView {
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
		label.textColor = .gray90
		label.layer.opacity = 0.0
		label.numberOfLines = 1
		label.font = .r12

		return label
	}()
	
	public let textField: UnderLineTextField = {
		let textField = UnderLineTextField()
		textField.translatesAutoresizingMaskIntoConstraints = false
		textField.font = .r15
		textField.underLineColor = .gray90
		textField.setPlaceholdColor(.gray90)
		
		return textField
	}()
	
	private lazy var warningLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .red100
		label.numberOfLines = 1
		label.font = .r12
		label.layer.opacity = 0.0
		
		return label
	}()
	
	public init(title: String) {
		super.init(frame: .zero)
		
		titleLabel.text = title
		textField.placeholder = title
		setupUI()
		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(textDidChange),
			name: UITextField.textDidChangeNotification,
			object: textField
		)
	}
	
	public convenience init(
		title: String,
		warningText: String
	) {
		self.init(title: title)
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
			stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
		])
	}
}

private extension OnBoardingTextField {
	@objc func textDidChange(_ notification: Notification) {
		guard
			let textField = notification.object as? UITextField,
			let text = textField.text
		else {
			return
		}
		
		if text.isEmpty {
			hasContent = false
		} else {
			hasContent = true
		}
		print(hasContent)
	}
	
	func changeNormalMode() {
		textField.underLineColor = .gray90
		warningLabel.layer.opacity = 0.0
	}
	
	func changeWarningMode() {
		textField.underLineColor = .red100
		warningLabel.layer.opacity = 1.0
	}
}
