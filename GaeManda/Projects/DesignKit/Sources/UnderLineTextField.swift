import UIKit

public class UnderLineTextField: UITextField {
	public override var selectedTextRange: UITextRange? {
		get { return super.selectedTextRange }
		set {
			super.selectedTextRange = newValue
		}
	}
	
	private let textPadding = UIEdgeInsets(
		top: 0,
		left: 10,
		bottom: 0,
		right: 0
	)
	
	public var selecetedRange: NSRange? {
		guard let range = self.selectedTextRange else { return nil }
		let location = offset(from: beginningOfDocument, to: range.start)
		let length = offset(from: range.start, to: range.end)
		
		return NSRange(location: location, length: length)
	}
	
	public lazy var underLineColor: UIColor = .black {
		didSet {
			self.underLineView.backgroundColor = underLineColor
		}
	}
	
	private lazy var underLineView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = self.underLineColor
		
		return view
	}()
	
	public init() {
		super.init(frame: .zero)
		setupUI()
	}
	
	public required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	private func setupUI() {
		addSubview(underLineView)
		
		NSLayoutConstraint.activate([
			underLineView.topAnchor.constraint(equalTo: self.bottomAnchor, constant: 4),
			underLineView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			underLineView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			underLineView.heightAnchor.constraint(equalToConstant: 1)
		])
	}
}

public extension UnderLineTextField {
	func setLeftImage(_ imageName: String) {
		let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 34, height: 24))
		let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
		imageView.image = UIImage(systemName: imageName)
		imageView.tintColor = .black
		leftPaddingView.addSubview(imageView)
		leftView = leftPaddingView
		leftViewMode = .always
	}
}
