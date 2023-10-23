//
//  DropDownView.swift
//  DesignKit
//
//  Created by jung on 10/17/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import GMDExtensions

public final class DropDownView: UIView {
	// MARK: - Properties
	public weak var listener: DropDownListener?
	public weak var anchorView: AnchorView?
	
	/// DropDown을 띄울 Constraint를 적용합니다.
	private var dropDownConstraints: ((ConstraintMaker) -> Void)?
	
	/// DropDown을 display할지 결정합니다.
	public var isDisplayed: Bool = false {
		didSet {
			isDisplayed ? displayDropDown(with: dropDownConstraints) : hideDropDown()
		}
	}

	/// DropDown에 띄울 목록들을 정의합니다.
	public var dataSource = [String]() {
		didSet { dropDownTableView.reloadData() }
	}
		
	/// DropDown의 현재 선택된 항목을 알 수 있습니다.
	public private(set) var selectedOption: String?
	
	// MARK: - UI Components
	fileprivate let dropDownTableView = DropDownTableView()
	
	// MARK: - Initializers
	public init() {
		super.init(frame: .zero)
		dropDownTableView.dataSource = self
		dropDownTableView.delegate = self
	}
	
	convenience public init(selectedOption: String) {
		self.init()
		self.selectedOption = selectedOption
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: - UITableViewDataSource
extension DropDownView: UITableViewDataSource {
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return dataSource.count
	}
	
	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueCell(DropDownCell.self, for: indexPath)
		if let selectedOption = self.selectedOption,
			 selectedOption == dataSource[indexPath.row] {
			cell.isSelected = true
		}
		
		cell.configure(with: dataSource[indexPath.row])
		
		return cell
	}
}

// MARK: - UITableViewDataSource
extension DropDownView: UITableViewDelegate {
	public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		listener?.dropdown(self, didSelectRowAt: indexPath)
		selectedOption = dataSource[indexPath.row]
		dropDownTableView.selectRow(at: indexPath)
		isDisplayed = false
	}
}

// MARK: - DropDown Logic
extension DropDownView {
	/// DropDownList를 보여줍니다.
	public func displayDropDown(with constraints: ((ConstraintMaker) -> Void)?) {
		guard let constraints = constraints else { return }
				
		UIWindow.key?.addSubview(dropDownTableView)
		dropDownTableView.snp.makeConstraints(constraints)
	}
	
	/// DropDownList를 숨김니다.
	public func hideDropDown() {
		dropDownTableView.removeFromSuperview()
		dropDownTableView.snp.removeConstraints()
	}
	
	public func setConstraints(_ closure: @escaping (_ make: ConstraintMaker) -> Void) {
		self.dropDownConstraints = closure
	}
}

public extension Reactive where Base: DropDownView {
	var selectedOption: ControlEvent<String> {
		let source = base.dropDownTableView.rx.itemSelected.map { base.dataSource[$0.row] }
		
		return ControlEvent(events: source)
	}
}
