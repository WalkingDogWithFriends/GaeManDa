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
		imageView.translatesAutoresizingMaskIntoConstraints = false
		
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
		imageView.snp.makeConstraints { make in
				make.top.equalToSuperview()
				make.leading.equalToSuperview()
				make.trailing.equalToSuperview()
		}

		titleLabel.snp.makeConstraints { make in
				make.top.equalTo(imageView.snp.bottom).offset(8)
				make.leading.equalToSuperview()
				make.trailing.equalToSuperview()
				make.bottom.equalToSuperview()
		}
	}
}
