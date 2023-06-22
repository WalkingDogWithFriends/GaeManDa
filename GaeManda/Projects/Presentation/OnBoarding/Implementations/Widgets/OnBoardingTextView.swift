import UIKit
import Extensions
import DesignKit

class OnBoardingTextView: UIView {
	public lazy var isWarning = false {
		didSet {
			if isWarning == true {
				changeWarningMode()
			} else {
				changeNormalMode()
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
		label.numberOfLines = 1
		label.font = .systemFont(ofSize: 12)
		
		return label
	}()
	
	private let textField: UnderLineTextField = {
		let textField = UnderLineTextField()
		textField.translatesAutoresizingMaskIntoConstraints = false
		
		return textField
	}()
	
	private let warningLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .init(hexCode: "FF0000")
		label.numberOfLines = 1
		label.font = .systemFont(ofSize: 12)
		
		return label
	}()
	
	private lazy var maximumTextCountLabel: UILabel = {
		let label = UILabel()
		label.textColor = .init(hexCode: "979797")
		label.font = .systemFont(ofSize: 12)
		
		return label
	}()
	
	private lazy var maximumTextCount: Int = 0
	
	init(
		title: String,
		placeHolder: String
	) {
		super.init(frame: .zero)
		
		self.textField.placeholder = placeHolder
		self.titleLabel.text = title
		setupUI()
	}
	
	convenience init(
		title: String,
		placeHolder: String,
		warningText: String
	) {
		self.init(title: title, placeHolder: placeHolder)
		self.warningLabel.text = warningText
		setupUI()
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
			stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
		])
	}
	
	func displayMaximunTextCount(_ maximumTextCount: Int) {
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
}

private extension OnBoardingTextView {
	func changeNormalMode() {
		self.textField.underLineColor = .black
		self.warningLabel.isHidden = true
	}
	
	func changeWarningMode() {
		self.textField.underLineColor = .init(hexCode: "FF0000")
		self.warningLabel.isHidden = false
	}
	
	@objc func textDidChange(_ notification: Notification) {
		guard
			let textField = notification.object as? UITextField,
			let text = textField.text
		else {
			return
		}
		var count = text.count
		
		if text.count >= maximumTextCount {
			let index = text.index(text.startIndex, offsetBy: maximumTextCount)
			let newString = text[text.startIndex..<index]
			textField.text = String(newString)
			count = 20
		}
		
		maximumTextCountLabel.text = "\(count)/\(maximumTextCount)"
	}
}
