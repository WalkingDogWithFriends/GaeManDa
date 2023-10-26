//
//  UITableView+Extension.swift
//  GMDExtensions
//
//  Created by 김영균 on 2023/08/11.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit

// MARK: - UIKit
public extension UITableView {
	/// Returns a cell for the table view.
	/// - Parameters:
	/// 	- type: The type of cell to return. (ex: `MyCell.self`)
	/// 	- indexPath: The index path of the cell.
	func cellForRow<T: UITableViewCell>(_ type: T.Type, at indexPath: IndexPath) -> T {
		let identifier = String(describing: type)
		guard let cell = cellForRow(at: indexPath) as? T else {
			fatalError("identifier: \(identifier) could not be row as \(T.self)")
		}
		return cell
	}
	
	/// Registers a cell with the table view.
	/// - Parameter type: The type of cell to register. (ex: `MyCell.self`)
	func registerCell<T: UITableViewCell>(_ type: T.Type) {
		let identifier = String(describing: type)
		register(T.self, forCellReuseIdentifier: identifier)
	}
	
	/// Dequeues a cell from the table view.
	/// - Parameter type: The type of cell to dequeue. (ex: `MyCell.self`)
	func dequeueCell<T: UITableViewCell>(_ type: T.Type, for indexPath: IndexPath) -> T {
		let identifier = String(describing: type)
		guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
			fatalError("identifier: \(identifier) could not be dequeued as \(T.self)")
		}
		return cell
	}
	
	/// Registers a header/footer with the table view.
	/// - Parameter type: The type of header/footer to register. (ex: `MyHeaderFooter.self`)
	func registerHeaderFooter<T: UITableViewHeaderFooterView>(_ type: T.Type) {
		let identifier = String(describing: type)
		register(T.self, forHeaderFooterViewReuseIdentifier: identifier)
	}
	
	/// Dequeues a header/footer from the table view.
	/// - Parameter type: The type of header/footer to dequeue. (ex: `MyHeaderFooter.self`)
	func dequeueHeaderFooter<T: UITableViewHeaderFooterView>(_ type: T.Type) -> T {
		let identifier = String(describing: type)
		guard let headerFooter = dequeueReusableHeaderFooterView(withIdentifier: identifier) as? T else {
			fatalError("identifier: \(identifier) could not be dequeued as \(T.self)")
		}
		return headerFooter
	}
}
