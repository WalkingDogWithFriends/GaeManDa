//
//  DogCharacterCollectionViewLayout.swift
//  CorePresentation
//
//  Created by jung on 11/16/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit

final class DogCharacterCollectionViewLayout: UICollectionViewFlowLayout {
	override init() {
		super.init()
		
		estimatedItemSize = UICollectionViewFlowLayout.automaticSize
		minimumLineSpacing = 16
		minimumInteritemSpacing = 8
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		let attributes = super.layoutAttributesForElements(in: rect)
		
		// contentView의 left margin
		var leftMargin = 0.0
		var maxY: CGFloat = -1.0
		
		attributes?
			.filter { $0.representedElementCategory == .cell }
			.forEach { layoutAttribute in
				// 각 row의 첫번째 cell인 경우
				if layoutAttribute.frame.origin.y >= maxY {
					leftMargin = 0.0
				}
				
				layoutAttribute.frame.origin.x = leftMargin
				
				// 다음 cell의 left margin 계산
				leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
				
				maxY = max(layoutAttribute.frame.maxY, maxY)
			}
		
		return attributes
	}
}
