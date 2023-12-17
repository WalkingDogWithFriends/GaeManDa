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

public protocol DropDownDelegate: AnyObject {
	func dropdown(_ dropDown: DropDownView, didSelectRowAt indexPath: IndexPath)
}

public final class DropDownView: UIView {
	// MARK: - Properties
	public weak var delegate: DropDownDelegate?
	
	/// DropDown을 띄울 Constraint를 적용합니다.
	private var dropDownConstraints: ((ConstraintMaker) -> Void)?
	private var becomeFirstResponderWhenTouchInside: Bool = false
	
	/// DropDown을 display할지 결정합니다.
	public var isDisplayed: Bool = false
	/// DropDown에 띄울 목록들을 정의합니다.
	public var dataSource = [String]() {
		didSet { dropDownTableView.reloadData() }
	}
		
	/// DropDown의 현재 선택된 항목을 알 수 있습니다.
	public private(set) var selectedOption: String?
	
	public override var canBecomeFirstResponder: Bool { true }
	public override var canResignFirstResponder: Bool { true }
	
	// MARK: - UI Components
	private let anchorView: UIView
	fileprivate let dropDownTableView = DropDownTableView()
	
	// MARK: - Initializers
	public init(anchorView: UIView) {
		self.anchorView = anchorView
		super.init(frame: .zero)
		anchorView.isUserInteractionEnabled = true
		self.isUserInteractionEnabled = true
		dropDownTableView.dataSource = self
		dropDownTableView.delegate = self
		
		setupUI()
	}
	
	public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
		return super.hitTest(point, with: event)
	}
	
	convenience public init(anchorView: UIView, selectedOption: String) {
		self.init(anchorView: anchorView)
		self.selectedOption = selectedOption
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		if isDisplayed == true {
			resignFirstResponder()
		} else {
			becomeFirstResponderWhenTouchInside = true
			becomeFirstResponder()
		}
	}
	
	public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
		becomeFirstResponderWhenTouchInside = false
	}
	
	public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		becomeFirstResponderWhenTouchInside = false
	}
	
	// MARK: - UI Responder Overriding
	@discardableResult
	public override func becomeFirstResponder() -> Bool {
		if self.isDisplayed == true { return true }
		super.becomeFirstResponder()

		displayDropDown(with: dropDownConstraints)
		self.isDisplayed = true

		return true
	}
	
	@discardableResult
	public override func resignFirstResponder() -> Bool {
		// 내부 터치 하면 FirstResponder가 anchorView로 지정되어 First Responder가 뺏기는 것을 방지합니다.
		if becomeFirstResponderWhenTouchInside == true { return false }
		if self.isDisplayed == false { return true }
		super.resignFirstResponder()

		hideDropDown()
		self.isDisplayed = false
		
		return true
	}
}

// MARK: - UI Setting
private extension DropDownView {
	func setupUI() {
		self.addSubview(anchorView)
		anchorView.snp.makeConstraints { $0.edges.equalToSuperview() }
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
		delegate?.dropdown(self, didSelectRowAt: indexPath)
		selectedOption = dataSource[indexPath.row]
		dropDownTableView.selectRow(at: indexPath)
		resignFirstResponder()
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

	var isSelectedOption: ControlEvent<Bool> {
		let itemSelected = base.dropDownTableView.rx.itemSelected.map { _ in true }
		let source = Observable.of(false).concat(itemSelected)
		
		return ControlEvent(events: source)
	}
}
