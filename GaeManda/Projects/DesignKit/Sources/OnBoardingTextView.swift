import UIKit
import GMDExtensions

public final class OnBoardingTextView: UIView {
	public lazy var isWarning = false {
		didSet {
			if isWarning == true {
				changeWarningMode()
			} else {
				changeNormalMode()
			}
		}
	}
	
	public lazy var warningText: String = "" {
		didSet {
			warningLabel.text = warningText
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
	
	private let labelStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .horizontal
		stackView.alignment = .fill
		stackView.distribution = .fillEqually
		
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
	
	public let maximumTextCountLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .init(hexCode: "979797")
		label.numberOfLines = 1
		label.font = .systemFont(ofSize: 12)
		label.textAlignment = .right
		
		return label
	}()
	
	public let textView: UITextView = {
		let textView = UITextView()
		textView.translatesAutoresizingMaskIntoConstraints = false
		textView.layer.borderColor = UIColor.black.cgColor
		textView.layer.borderWidth = 1.5
		textView.layer.cornerRadius = 4
		
		return textView
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
	
	public init(title: String) {
		super.init(frame: .zero)
		
		titleLabel.text = title
		setupUI()
	}
	
	public convenience init(
		title: String,
		warningText: String
	) {
		self.init(title: title)
		self.warningText = warningText
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupUI() {
		addSubview(stackView)
		
		labelStackView.addArrangedSubview(titleLabel)
		labelStackView.addArrangedSubview(maximumTextCountLabel)

		stackView.addArrangedSubview(labelStackView)
		stackView.addArrangedSubview(textView)
		stackView.addArrangedSubview(warningLabel)
		
		NSLayoutConstraint.activate([
			stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			textView.heightAnchor.constraint(equalToConstant: 110),
			stackView.topAnchor.constraint(equalTo: self.topAnchor),
			stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
		])
	}
}

private extension OnBoardingTextView {
	func changeNormalMode() {
		textView.layer.borderColor = UIColor.black.cgColor
		warningLabel.layer.opacity = 0.0
	}
	
	func changeWarningMode() {
		textView.layer.borderColor = UIColor(hexCode: "FF0000").cgColor
		warningLabel.layer.opacity = 1.0
	}
}
