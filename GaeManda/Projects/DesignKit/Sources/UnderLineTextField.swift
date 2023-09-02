import UIKit
import SnapKit

public class UnderLineTextField: UITextField {
	public var selecetedRange: NSRange? {
		guard let range = self.selectedTextRange else { return nil }
		let location = offset(from: beginningOfDocument, to: range.start)
		let length = offset(from: range.start, to: range.end)
		
		return NSRange(location: location, length: length)
	}
		
	private let underLineView = UIView()
	
	public var underLineColor: UIColor? {
		didSet {
			underLineView.backgroundColor = underLineColor
		}
	}
	
	public init() {
		super.init(frame: .zero)
		setupUI()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
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
