import UIKit
import GMDExtensions

public class GMDRadioButton: UIButton {
	public override var isSelected: Bool {
		didSet {
			isSelected ? buttonSeleceted() : buttonDisSelected()
//			if isSelected == false {
//				buttonDisSelected()
//			} else {
//				buttonSeleceted()
//			}
		}
	}
	
	public init(title: String) {
		super.init(frame: .zero)
		
		self.layer.cornerRadius = 4
		self.backgroundColor = .gray60
		self.setTitleColor(.white, for: .normal)
		self.setTitle(title, for: .normal)
		self.titleLabel?.font = .b16
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	private func buttonDisSelected() {
		backgroundColor = .gray60
	}
	
	private func buttonSeleceted() {
		setTitleColor(.white, for: .normal)
		backgroundColor = .black
	}
}
