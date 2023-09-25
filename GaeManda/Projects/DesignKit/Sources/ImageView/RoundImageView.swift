import UIKit

public final class RoundImageView: UIImageView {
	public init() {
		super.init(frame: .zero)
		self.layer.masksToBounds = true
		contentMode = .scaleAspectFill
		backgroundColor = .gray40
	}
	
	public override init(image: UIImage?) {
		super.init(image: image)
		self.layer.masksToBounds = true
		contentMode = .scaleAspectFill
		backgroundColor = .gray40
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public override func layoutSubviews() {
		super.layoutSubviews()
		self.layer.cornerRadius = frame.height / 2
	}
}
