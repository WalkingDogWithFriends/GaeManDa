//
//  UICollectionView+Extension.swift
//  GMDExtensions
//
//  Created by 김영균 on 2023/08/14.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit

public extension UICollectionView {
	/// Registers a cell with the collection view.
	/// - Parameter type: The type of cell to register. (ex: `MyCell.self`)
	func registerCell<T: UICollectionViewCell>(_ type: T.Type) {
		let identifier = String(describing: type)
		register(T.self, forCellWithReuseIdentifier: identifier)
	}
	
	/// Dequeues a cell from the collection view.
	/// - Parameter type: The type of cell to dequeue. (ex: `MyCell.self`)
	func dequeueCell<T: UICollectionViewCell>(_ type: T.Type, for indexPath: IndexPath) -> T {
		let identifier = String(describing: type)
		guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? T else {
			fatalError("identifier: \(identifier) could not be dequeued as \(T.self)")
		}
		return cell
	}
	
	/// Registers a header with the collection view.
	/// - Parameter type: The type of header to register. (ex: `MyHeader.self`)
	func registerHeader<T: UICollectionReusableView>(_ type: T.Type) {
		let identifier = String(describing: type)
		register(
			type,
			forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
			withReuseIdentifier: identifier
		)
	}
	
	/// Dequeues a header from the collection view.
	/// - Parameter type: The type of header to dequeue. (ex: `MyHeader.self`)
	func dequeueHeader<T: UICollectionReusableView>(_ type: T.Type, for indexPath: IndexPath) -> T {
		let identifier = String(describing: type)
		guard let header = dequeueReusableSupplementaryView(
			ofKind: UICollectionView.elementKindSectionHeader,
			withReuseIdentifier: identifier,
			for: indexPath
		) as? T else {
			fatalError("identifier: \(identifier) could not be dequeued as \(T.self)")
		}
		return header
	}
	
	/// Registers a footer with the collection view.
	/// - Parameter type: The type of footer to register. (ex: `MyFooter.self`)
	func registerFooter<T: UICollectionReusableView>(_ type: T.Type) {
		let identifier = String(describing: type)
		register(
			type,
			forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
			withReuseIdentifier: identifier
		)
	}
	
	/// Dequeues a footer from the collection view.
	/// - Parameter type: The type of footer to dequeue. (ex: `MyFooter.self`)
	func dequeueFooter<T: UICollectionReusableView>(_ type: T.Type, for indexPath: IndexPath) -> T {
		let identifier = String(describing: type)
		guard let footer = dequeueReusableSupplementaryView(
			ofKind: UICollectionView.elementKindSectionFooter,
			withReuseIdentifier: identifier,
			for: indexPath
		) as? T else {
			fatalError("identifier: \(identifier) could not be dequeued as \(T.self)")
		}
		return footer
	}
}
