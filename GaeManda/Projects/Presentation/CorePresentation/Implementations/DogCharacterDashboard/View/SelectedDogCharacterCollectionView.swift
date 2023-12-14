//
//  SelectedDogCharacterCollectionView.swift
//  CorePresentation
//
//  Created by jung on 12/5/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import GMDExtensions

final class SelectedCharacterCollectionView: UICollectionView {
	private let flowLayout: UICollectionViewFlowLayout = {
		let layout = UICollectionViewFlowLayout()
		layout.minimumInteritemSpacing = 16
		layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
		layout.scrollDirection = .horizontal
		
		return layout
	}()
	
	fileprivate let contentSizeRelay: BehaviorRelay<CGSize>
	
	override var contentSize: CGSize {
		didSet {
			guard oldValue != contentSize else { return }
			contentSizeRelay.accept(contentSize)
		}
	}
	
	init() {
		self.contentSizeRelay = BehaviorRelay(value: .zero)
		
		super.init(frame: .zero, collectionViewLayout: flowLayout)
		contentSizeRelay.accept(contentSize)
		registerCell(SelectedDogCharacterCell.self)
		self.showsHorizontalScrollIndicator = false
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: - Reactive Extension
extension Reactive where Base: SelectedCharacterCollectionView {
	var contentSize: ControlEvent<CGSize> {
		return ControlEvent(events: base.contentSizeRelay.asObservable())
	}
}
