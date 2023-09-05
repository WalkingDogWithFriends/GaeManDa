import UIKit
import SnapKit

public class UnderLineTextField: UITextField {
	public override var text: String? {
		didSet {
			// textField.text를 통해 값을 설정할 때, rx.text로 이벤트를 방출시키기 위해 추가한 코드
			sendActions(for: .valueChanged)
		}
	}
	
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
		setViewHierarchy()
		setConstraints()
	}
	
	private func setViewHierarchy() {
		addSubview(underLineView)
	}
	
	private func setConstraints() {
		underLineView.snp.makeConstraints { make in
			make.top.equalTo(self.snp.bottom).offset(4)
			make.leading.trailing.equalToSuperview()
			make.height.equalTo(1)
		}
	}
}
