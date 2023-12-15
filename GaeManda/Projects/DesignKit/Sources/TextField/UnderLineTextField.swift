import UIKit
import SnapKit

public class UnderLineTextField: UITextField {
	// MARK: - Properties
	/// TextField의 padding을 정의할 수 있습니다.
	public var padding = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0) {
		didSet {
			setNeedsDisplay()
		}
	}
		
	public override var text: String? {
		didSet {
			// textField.text를 통해 값을 설정할 때, rx.text로 이벤트를 방출시키기 위해 추가한 코드
			NotificationCenter.default.post(name: UITextField.textDidChangeNotification, object: self)
			
			// rxSwift의 text이벤트를 위한 것
			sendActions(for: .allEditingEvents)
		}
	}
	
	public var selecetedRange: NSRange? {
		guard let range = self.selectedTextRange else { return nil }
		let location = offset(from: beginningOfDocument, to: range.start)
		let length = offset(from: range.start, to: range.end)
		
		return NSRange(location: location, length: length)
	}
	
	// MARK: - UI Components
	private let underLineView = UIView()
	
	public var underLineColor: UIColor = .black {
		didSet {
			underLineView.backgroundColor = underLineColor
		}
	}
	
	// MARK: - Initializers
	public init() {
		super.init(frame: .zero)
		setupUI()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func textFieldRect(forBounds bounds: CGRect) -> CGRect {
		let leftViewRect = super.leftViewRect(forBounds: bounds)
		var boundInset = bounds.inset(by: padding)
		let leftPadding: CGFloat = 8.0
		boundInset.origin.x += (leftViewRect.width + leftPadding)

		return boundInset
	}
	
	// MARK: - Method Override
	open override func textRect(forBounds bounds: CGRect) -> CGRect {
		return textFieldRect(forBounds: bounds)
	}
	
	open override func editingRect(forBounds bounds: CGRect) -> CGRect {
		return textFieldRect(forBounds: bounds)
	}
	
	open override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
		return textFieldRect(forBounds: bounds)
	}
	
	open override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
		var rightViewRect = super.rightViewRect(forBounds: bounds)
		
		rightViewRect.origin.x -= padding.right
		rightViewRect.origin.y -= (padding.bottom / 2)
		
		return rightViewRect
	}
	
	public override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
		var leftViewRect = super.leftViewRect(forBounds: bounds)
		
		leftViewRect.origin.x += padding.left
		leftViewRect.origin.y -= (padding.bottom / 2)

		return leftViewRect
	}
}

// MARK: - UI Methods
private extension UnderLineTextField {
	func setupUI() {
		setViewHierarchy()
		setConstraints()
	}
	
	func setViewHierarchy() {
		addSubview(underLineView)
	}
	
	func setConstraints() {
		underLineView.snp.makeConstraints { make in
			make.top.equalTo(self.snp.bottom)
			make.leading.trailing.equalToSuperview()
			make.height.equalTo(1)
		}
	}
}
