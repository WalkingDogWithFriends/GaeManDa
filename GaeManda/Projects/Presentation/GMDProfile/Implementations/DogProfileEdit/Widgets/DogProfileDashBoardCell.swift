//
//  DogProfileDashBoardCell.swift
//  GMDProfileImpl
//
//  Created by jung on 2023/08/01.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import SnapKit
import DesignKit

final class DogProfileDashBoardCell: UICollectionViewCell {
	lazy var isEdited: Bool = false {
		didSet {
			imageView.layer.borderWidth = isEdited ? 1 : 0
		}
	}
	
	let imageView = RoundImageView()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
		
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
	}

	func configuration(image: UIImage?) {
		imageView.image = image
		
		contentView.addSubview(imageView)
		imageView.layer.borderColor = UIColor.green100.cgColor
		
		imageView.snp.makeConstraints { make in
			make.height.width.equalTo(56)
			make.top.bottom.leading.trailing.equalToSuperview()
		}
	}
}
