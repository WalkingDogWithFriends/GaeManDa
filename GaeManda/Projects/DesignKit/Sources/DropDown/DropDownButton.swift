//
//  DropDownButton.swift
//  DesignKit
//
//  Created by jung on 10/16/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import SnapKit
import GMDExtensions

public final class DropDownButton: UIView {
	// MARK: - DropDownTextMode
	public enum DropDownTextMode {
		case title
		case option
	}
	
	// MARK: - Properties
	public var textMode: DropDownTextMode = .title {
		didSet {
			switch textMode {
			case .title:
				label.textColor = .gray90
			case .option:
				label.textColor = .black
			}
		}
	}
	
	// MARK: - UI Components
	private let label: UILabel = {
		let label = UILabel()
		label.textColor = .black
		label.font = .r15
		
		return label
	}()

	private let downImageView: UIImageView = {
		let imageView = UIImageView(
			image: UIImage(systemName: "chevron.down")
		)
		imageView.tintColor = .gray90
		
		return imageView
	}()
	
	// MARK: - Initializers
	public init() {
		super.init(frame: .zero)
		layer.cornerRadius = 4
		layer.borderWidth = 1
		layer.borderColor = UIColor.gray90.cgColor
		
		setupUI()
	}
	
	public convenience init(text: String, mode: DropDownTextMode) {
		self.init()
		setTitle(text, for: mode)
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: - UI Methods
private extension DropDownButton {
	func setupUI() {
		setViewHierarchy()
		setConstraints()
	}
	
	func setViewHierarchy() {
		addSubviews(label, downImageView)
	}
	
	func setConstraints() {
		label.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(8)
			make.top.equalToSuperview().offset(12)
			make.bottom.equalToSuperview().offset(-12)
		}
		
		downImageView.snp.makeConstraints { make in
			make.centerY.equalTo(label)
			make.trailing.equalToSuperview().offset(-12)
		}
	}
}

// MARK: - Public Methods
public extension DropDownButton {
	func setTitle(_ title: String?, for mode: DropDownTextMode) {
		self.textMode = mode
		self.label.text = title
	}
}
