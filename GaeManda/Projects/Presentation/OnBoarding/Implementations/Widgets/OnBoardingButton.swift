import UIKit
import DesignKit
import GMDExtensions

class OnBoardingButton: UIButton {
	var buttonIsSelected: Bool = false {
		didSet {
			if buttonIsSelected == false {
				buttonDisSelected()
			} else {
				buttonSeleceted()
			}
		}
	}
	
	init(title: String) {
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
