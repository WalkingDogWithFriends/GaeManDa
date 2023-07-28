//
//  TabBarButton.swift
//  Dev-GaeManda
//
//  Created by jung on 2023/07/18.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import DesignKit

final class TabBarButton: UIView {
	var isSelected: Bool = false {
		didSet {
			if isSelected == true {
				titleLabel.font = .b12
			} else {
				titleLabel.font = .r12
			}
		}
	}
	
	private let titleLabel: UILabel = {
		let label = UILabel()
		label.font = .r12
		label.textAlignment = .center
		
		return label
	}()
	
	private let imageView: UIImageView
	
	init(imageView: UIImageView, title: String) {
		self.imageView = imageView
		super.init(frame: .zero)
		titleLabel.text = title
		setupUI()
	}
	
	init(image: UIImage?, title: String) {
		imageView = UIImageView(image: image)
		super.init(frame: .zero)
		titleLabel.text = title
		setupUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError()
	}
	
	private func setupUI() {
		imageView.tintColor = .black
		
		setupSubViews()
		setConstraints()
	}
	
	private func setupSubViews() {
		addSubview(imageView)
		addSubview(titleLabel)
	}
	
	private func setConstraints() {
		NSLayoutConstraint.activate([
			imageView.topAnchor.constraint(equalTo: topAnchor),
			imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
			imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
			
			titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
			titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
			titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
			titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
		])
	}
}
