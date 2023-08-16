//
//  DogProfileDashBoard.swift
//  GMDProfileImpl
//
//  Created by jung on 2023/08/01.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import SnapKit

final class DogProfileDashBoard: UICollectionView {
	/// For Authomatic Width
	override var contentSize: CGSize {
		didSet {
			invalidateIntrinsicContentSize()
		}
	}
	
	override var intrinsicContentSize: CGSize {
		var contentSize = self.contentSize
		contentSize.width += 10
		return contentSize
	}
	
	// MARK: Initalizer
	init() {
		let layout = UICollectionViewFlowLayout()
		layout.minimumLineSpacing = 16
		layout.scrollDirection = .horizontal
		layout.itemSize = UICollectionViewFlowLayout.automaticSize
		layout.estimatedItemSize = CGSize(width: 56, height: 56)
		
		super.init(frame: .zero, collectionViewLayout: layout)
	}
	
	required init?(coder: NSCoder) {
		fatalError()
	}
	
	/// resize Width when reloadData
	override func reloadData() {
		super.reloadData()
		self.invalidateIntrinsicContentSize()
	}
}
