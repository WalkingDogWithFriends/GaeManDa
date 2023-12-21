//
//  ClusterCentroid.swift
//  GMDMap
//
//  Created by 김영균 on 12/15/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import SnapKit
import DesignKit

enum CentroidScale: Int {
	case tiny = 1
	case small = 2
	case medium = 3
	case large = 4
	case huge = 5
}

extension CentroidScale {
	var size: CGSize {
		switch self {
		case .tiny:
			return CGSize(width: 52, height: 52)
			
		case .small:
			return CGSize(width: 60, height: 60)
			
		case .medium:
			return CGSize(width: 68, height: 68)
			
		case .large:
			return CGSize(width: 76, height: 76)
			
		case .huge:
			return CGSize(width: 84, height: 84)
		}
	}
}

final class ClusterCentroid: UIView {
	private let titleLabel: UILabel = {
		let label = UILabel()
		label.font = .jalnan28
		label.textColor = .darkGreen100
		label.textAlignment = .center
		return label
	}()
	
	private let scale: CentroidScale
	
	// MARK: - Initializers
	init(scale: CentroidScale) {
		self.scale = scale
		super.init(frame: .zero)
		setViewAttributes()
		setViewHierarchies()
		setViewConstraints()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

private extension ClusterCentroid {
	func setViewAttributes() {
		titleLabel.text = "\(scale.rawValue)"
		backgroundColor = .green70.withAlphaComponent(0.7)
		layer.cornerRadius = scale.size.width / 2
		layer.masksToBounds = false
		layer.shadowPath = UIBezierPath(
			roundedRect: .init(origin: .zero, size: scale.size),
			cornerRadius: scale.size.width / 2
		).cgPath
		layer.shadowColor = UIColor.black.cgColor
		layer.shadowOpacity = 0.3
		layer.shadowOffset = CGSize(width: 1, height: 2)
		layer.shadowRadius = 4
	}
	
	func setViewHierarchies() {
		addSubviews(titleLabel)
	}
	
	func setViewConstraints() {
		titleLabel.snp.makeConstraints {
			$0.center.equalToSuperview()
		}
	}
}
