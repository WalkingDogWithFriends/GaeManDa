import UIKit

public final class RoundImageView: UIImageView {
	public init() {
		super.init(frame: .zero)
		self.layer.masksToBounds = true
		contentMode = .scaleAspectFill
	}
	
	required init?(coder: NSCoder) {
		fatalError()
	}
	
	public override func layoutSubviews() {
		super.layoutSubviews()
		self.layer.cornerRadius = frame.height / 2
	}
}
