//
//  DropDownView.swift
//  DesignKit
//
//  Created by jung on 10/17/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import SnapKit
import GMDExtensions

public final class DropDownView: UIView {
	// MARK: - Properties
	public weak var listener: DropDownListener?
	
	/// DropDownView에서 button의 buttom Constraint를 리턴합니다.
	public var viewBottom: ConstraintItem {
		self.dropDownButton.snp.bottom
	}

	/// DropDown을 띄울지 여부입니다.
	public var isDisplayed: Bool = false {
		didSet {
			isDisplayed ? displayDropDown() : hideDropDown()
		}
	}
	
	/// DropDown에 띄울 목록들을 정의합니다.
	public var dataSource = [String]() {
		didSet {
			updateDropDownTableViewHeight()
			dropDownTableView.reloadData()
		}
	}
		
	/// DropDown의 현재 선택된 항목을 알 수 있습니다.
	public private(set) var selectedOption: String?
		
	// MARK: - UI Components
	private let stackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.alignment = .fill
		stackView.distribution = .equalSpacing
		stackView.spacing = 0
		
		return stackView
	}()
	
	private let dropDownButton = DropDownButton()
	private let dropDownTableView = DropDownTableView()
	
	// MARK: - Initializers
	public init() {
		super.init(frame: .zero)
		dropDownTableView.dataSource = self
		dropDownTableView.delegate = self
		setupUI()
	}
	
	convenience public init(
		title: String? = nil,
		selectedOption: String? = nil
	) {
		self.init()
		self.selectedOption = selectedOption
		
		self.setButtonTitle(title)
		self.setButtonOption(selectedOption)
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: - UI Methods
private extension DropDownView {
	func setupUI() {
		dropDownTableView.backgroundColor = .red
		setViewHierarchy()
		setConstraints()
	}
	
	func setViewHierarchy() {
		addSubview(dropDownButton)
	}
	
	func setConstraints() {
		dropDownButton.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
	}
}

// MARK: - UITableViewDelegate
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
		dropDownTableView.selectRow(at: indexPath.row)
		setButtonOption(selectedOption)
		isDisplayed = false
	}
}

// MARK: - DropDown Logic
extension DropDownView {
	private func updateDropDownTableViewHeight() {
		let height = min(CGFloat(dataSource.count) * 32, 160)
		UIView.animate(withDuration: 0.3) {
			self.dropDownTableView.snp.updateConstraints { make in
				make.height.equalTo(height)
			}
		}
	}
	
	/// DropDownList를 숨김니다.
	public func hideDropDown() {
		dropDownTableView.removeFromSuperview()
		dropDownTableView.snp.removeConstraints()
	}
	
	/// DropDownList를 보여줍니다.
	public func displayDropDown() {
		UIWindow.key?.addSubview(dropDownTableView)
		dropDownTableView.snp.makeConstraints { make in
			make.width.equalTo(dropDownButton.snp.width)
			make.leading.equalTo(dropDownButton)
			make.top.equalTo(viewBottom)
			make.height.equalTo(0)
		}
		updateDropDownTableViewHeight()
	}
	
	/// DropDownButton의 Title을 설정합니다.
	public func setButtonTitle(_ title: String?) {
		guard let title = title else { return }
		dropDownButton.setTitle(title, for: .title)
	}
	
	/// DropDownButton의 Title을 선택된 Option으로 설정합니다.
	public func setButtonOption(_ selectedOption: String?) {
		guard let selectedOption = selectedOption else { return }
		dropDownButton.setTitle(selectedOption, for: .option)
	}
}
