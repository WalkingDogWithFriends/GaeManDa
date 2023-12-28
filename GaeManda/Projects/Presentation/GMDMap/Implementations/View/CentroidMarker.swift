//
//  CentroidMarker.swift
//  GMDMap
//
//  Created by 김영균 on 12/15/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture
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

final class CentroidMarker: UIView {
	private let titleLabel: UILabel = {
		let label = UILabel()
		label.font = .jalnan28
		label.textColor = .darkGreen100
		label.textAlignment = .center
		return label
	}()
	
	private let scale: CentroidScale
	let group: [GMDMapViewModel]
	let centroid: CGPoint
	
	// MARK: - Initializers
	init(
		centroid: CGPoint,
		group: [GMDMapViewModel]
	) {
		self.centroid = centroid
		self.group = group
		if group.count <= 1 {
			self.scale = .tiny
		} else if group.count <= 3 {
			self.scale = .small
		} else if group.count <= 4 {
			self.scale = .medium
		} else if group.count <= 5 {
			self.scale = .large
		} else {
			self.scale = .huge
		}
		
		super.init(frame: .init(origin: centroid, size: scale.size))
		setViewAttributes()
		setViewHierarchy()
		setConstraints()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

private extension CentroidMarker {
	func setViewAttributes() {
		titleLabel.text = "\(group.count)"
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
	
	func setViewHierarchy() {
		addSubviews(titleLabel)
	}
	
	func setConstraints() {
		titleLabel.snp.makeConstraints {
			$0.center.equalToSuperview()
		}
	}
}

extension Reactive where Base: CentroidMarker {
	var tap: ControlEvent<Void> {
		let source = base.rx.tapGesture().when(.recognized).map { _ in }
		
		return ControlEvent(events: source)
	}
}
