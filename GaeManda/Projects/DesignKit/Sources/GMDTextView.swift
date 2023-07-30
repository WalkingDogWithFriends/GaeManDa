import UIKit
import SnapKit

public final class GMDTextView: UIView {
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
	
	private lazy var warningLabel: UILabel = {
		let label = UILabel()
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
