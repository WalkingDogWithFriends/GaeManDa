//
//  IndicatorView.swift
//  GMDProfileImpl
//
//  Created by jung on 2023/07/20.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import SnapKit
import DesignKit

final class DogPageControl: UIStackView {
	// MARK: - Properties
	var numberOfPages: Int = 0 {
		didSet {
			setupUI()
		}
	}
	
	var currentPage: Int = 0 {
		didSet {
			setIndicatorsColor()
		}
	}
	
	/// indicator color for current page
	var currentIndicatorColor: UIColor = .green60
	/// indicator color when deseleted
	var indicatorColor: UIColor = .gray40
	
	// MARK: - UI Components
	private var pageIndicators: [UIView] = []
		
	// MARK: - Initializers
	init() {
		super.init(frame: .zero)
		axis = .horizontal
		spacing = 8
		alignment = .fill
		distribution = .fillEqually
	}
	
	@available(*, unavailable)
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - layoutSubviews
	override func layoutSubviews() {
		super.layoutSubviews()

		// make Indicator views round
		pageIndicators.forEach {
			$0.layer.cornerRadius = $0.bounds.width / 2
			$0.clipsToBounds = true
		}
	}
}

// MARK: - UI Setting
private extension DogPageControl {
	func setupUI() {
		// remove before page indicators
		pageIndicators.forEach { $0.removeFromSuperview() }
		pageIndicators = []
		
		setViewHierarchy()
		setConstraints()
		setIndicatorsColor()
	}
	
	func setViewHierarchy() {
		(0..<numberOfPages).forEach { _ in
			let view = UIView()
			addArrangedSubviews(view)
			pageIndicators.append(view)
		}
	}
	
	func setConstraints() {
		pageIndicators.forEach {
			$0.snp.makeConstraints { make in
				make.width.height.equalTo(24)
			}
		}
	}
	
	func setIndicatorsColor() {
		guard currentPage >= 0, currentPage < numberOfPages else { return }
		
		for (idx, item) in pageIndicators.enumerated() {
			item.backgroundColor = idx == currentPage ? currentIndicatorColor : indicatorColor
		}
	}
}
