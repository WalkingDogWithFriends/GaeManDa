import UIKit
import Extensions

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
		self.backgroundColor = .init(hexCode: "F4F4F4")
		self.setTitleColor(.init(hexCode: "CDCCCC"), for: .normal)
		self.setTitle(title, for: .normal)
		self.titleLabel?.font = .systemFont(ofSize: 14)
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	private func buttonDisSelected() {
		setTitleColor(.init(hexCode: "CDCCCC"), for: .normal)
		backgroundColor = .init(hexCode: "F4F4F4")
	}
	
	private func buttonSeleceted() {
		setTitleColor(.white, for: .normal)
		backgroundColor = .black
	}
}
