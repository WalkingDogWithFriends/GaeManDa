//
//  UITableView+Reactive.swift
//  GMDExtensions
//
//  Created by 김영균 on 9/25/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import RxSwift

// MARK: - RxSwift
public extension Reactive where Base: UITableView {
	func items<
		Sequence: Swift.Sequence,
		Cell: UITableViewCell,
		Source: ObservableType
	>(cellType: Cell.Type = Cell.self)
	-> (_ source: Source)
	-> (_ configureCell: @escaping (Int, Sequence.Element, Cell) -> Void)
	-> Disposable
	where Source.Element == Sequence {
		return self.items(cellIdentifier: cellType.identifier, cellType: cellType)
	}
}
