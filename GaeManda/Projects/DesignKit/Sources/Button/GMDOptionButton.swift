import UIKit
import GMDExtensions

public class GMDOptionButton: UIButton {
	// MARK: - Properties
	public override var isSelected: Bool {
		didSet {
			isSelected ? buttonSeleceted() : buttonDisSelected()
		}
	}
	
	// MARK: - Initializers
	public init(title: String, isSelected: Bool = false) {
		super.init(frame: .zero)
		
		self.layer.cornerRadius = 4
		self.setTitle(title, for: .normal)
		self.titleLabel?.font = .b16
		
		defer { self.isSelected = isSelected }
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	// MARK: - Methods
	private func buttonDisSelected() {
		backgroundColor = .gray60
	}
	
	private func buttonSeleceted() {
		setTitleColor(.white, for: .normal)
		backgroundColor = .black
	}
}
