//
//  DropDownTableView.swift
//  DesignKit
//
//  Created by jung on 10/17/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import GMDExtensions

final class DropDownTableView: UITableView {
	// MARK: - Initializers
	override init(frame: CGRect, style: UITableView.Style) {
		super.init(frame: frame, style: style)
		
		layer.cornerRadius = 4
		layer.borderWidth = 1
		layer.borderColor = UIColor.gray90.cgColor
		separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		registerCell(DropDownCell.self)
		
		self.rowHeight = 32
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Methods
	func deselectAllCell() {
		self.visibleCells.forEach { $0.isSelected = false }
	}
	
	func selectRow(at index: Int) {
		deselectAllCell()
		self.visibleCells.enumerated().forEach { (idx, cell) in
			if index == idx { cell.isSelected = true }
		}
	}
}
