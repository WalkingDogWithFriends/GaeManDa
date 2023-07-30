import UIKit
import SnapKit

public class UnderLineTextField: UITextField {
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
	
	public var underLineColor: UIColor? {
		didSet {
			underLineView.backgroundColor = underLineColor
		}
	}
	
	private lazy var underLineView: UIView = {
		let view = UIView()
		
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
		
		underLineView.snp.makeConstraints { make in
			make.top.equalTo(self.snp.bottom).offset(4)
			make.leading.trailing.equalToSuperview()
			make.height.equalTo(1)
		}
	}
}
