import UIKit
import RxCocoa

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
