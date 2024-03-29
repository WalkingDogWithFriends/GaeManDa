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
	// MARK: - Properties
	private let minHeight: CGFloat = 0
	private let maxHeight: CGFloat = 192
	
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
	
	// MARK: - override Layout Methods
	override public func layoutSubviews() {
		super.layoutSubviews()
		if bounds.size != intrinsicContentSize {
			invalidateIntrinsicContentSize()
		}
	}
	
	override public var intrinsicContentSize: CGSize {
		layoutIfNeeded()
		if contentSize.height > maxHeight {
			return CGSize(width: contentSize.width, height: maxHeight)
		} else if contentSize.height < minHeight {
			return CGSize(width: contentSize.width, height: minHeight)
		} else {
			return contentSize
		}
	}
}

// MARK: - Internal Methods
extension DropDownTableView {
	func deselectAllCell() {
		self.visibleCells.forEach { $0.isSelected = false }
	}
	
	func selectRow(at indexPath: IndexPath) {
		deselectAllCell()
		self.cellForRow(DropDownCell.self, at: indexPath).isSelected = true
	}
}
