import UIKit

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
		stackView.spacing = 8
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
		label.textColor = .gray90
		label.numberOfLines = 1
		label.font = .r12
		
		return label
	}()
	
	public let maximumTextCountLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .gray90
		label.numberOfLines = 1
		label.font = .r12
		label.textAlignment = .right
		
		return label
	}()
	
	public let textView: UITextView = {
		let textView = UITextView()
		textView.translatesAutoresizingMaskIntoConstraints = false
		textView.layer.borderColor = UIColor.gray90.cgColor
		textView.layer.borderWidth = 1.5
		textView.layer.cornerRadius = 4
		textView.font = .r12
		
		return textView
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
		addSubview(labelStackView)
		addSubview(textView)
		addSubview(warningLabel)

		labelStackView.addArrangedSubview(titleLabel)
		labelStackView.addArrangedSubview(maximumTextCountLabel)

		NSLayoutConstraint.activate([
			labelStackView.topAnchor.constraint(equalTo: self.topAnchor),
			labelStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			labelStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			
			textView.topAnchor.constraint(equalTo: labelStackView.bottomAnchor, constant: 7),
			textView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			textView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			textView.heightAnchor.constraint(equalToConstant: 127),
			
			warningLabel.topAnchor.constraint(equalTo: textView.bottomAnchor),
			warningLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			warningLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			warningLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
		])
	}
}

private extension OnBoardingTextView {
	func changeNormalMode() {
		textView.layer.borderColor = UIColor.gray90.cgColor
		warningLabel.layer.opacity = 0.0
	}
	
	func changeWarningMode() {
		textView.layer.borderColor = UIColor.red100.cgColor
		warningLabel.layer.opacity = 1.0
	}
}
