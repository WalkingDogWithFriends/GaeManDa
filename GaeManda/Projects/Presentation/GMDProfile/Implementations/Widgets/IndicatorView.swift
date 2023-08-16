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

final class IndicatorView: UIStackView {
	var indicatorCount: Int = 0 {
		didSet {
			indicators = Array(indicatorViews[0..<indicatorCount])
			setupUI()
		}
	}
	
	private let firstView: UIView = {
		let view = UIView()
		view.clipsToBounds = true
		view.backgroundColor = .green60
		
		return view
	}()
	
	private let secondView: UIView = {
		let view = UIView()
		view.clipsToBounds = true
		view.backgroundColor = .gray40
		
		return view
	}()
	
	private let thirdView: UIView = {
		let view = UIView()
		view.clipsToBounds = true
		view.backgroundColor = .gray40
		
		return view
	}()
	
	private lazy var indicatorViews = [firstView, secondView, thirdView]
	private var indicators: [UIView] = []
	
	init() {
		super.init(frame: .zero)
		axis = .horizontal
		spacing = 8
		alignment = .fill
		distribution = .fillEqually
	}
	
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupUI() {
		indicators.forEach { addArrangedSubview($0) }
		
		indicators.forEach {
			$0.snp.makeConstraints { make in
				make.width.height.equalTo(19)
			}
		}
	}
	override func layoutSubviews() {
		super.layoutSubviews()
		
		indicators.forEach { $0.layer.cornerRadius = $0.bounds.width / 2 }
	}
}

// MARK: indicatorView Action
extension IndicatorView {
	func indicatorDidChange(_ index: Int) {
		guard index >= 0, index < indicatorCount else { return }
		
		for (idx, item) in indicators.enumerated() {
			item.backgroundColor = idx == index ? .green60 : .gray40
		}
	}
}
