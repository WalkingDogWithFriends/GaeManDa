//
//  ProfileImageView.swift
//  DesignKit
//
//  Created by jung on 12/15/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import RxGesture
import RxSwift
import SnapKit

public final class ProfileImageView: UIView {
	public enum ProfileImageViewMode {
		/// 수정 가능한 이미지 뷰
		case editable
		/// 수정 불가능한 이미지 뷰
		case unEditable
	}
	
	// MARK: - Properties
	public var imageViewBackgroundColor: UIColor? {
		get { self.profileImageView.backgroundColor }
		set { self.profileImageView.backgroundColor = newValue }
	}
	
	public var image: UIImage? {
		get { profileImageView.image }
		set {
			DispatchQueue.main.async {
				self.profileImageView.image = newValue
			}
		}
	}
	
	private let mode: ProfileImageViewMode
	
	// MARK: - UI Components
	fileprivate let profileImageView: RoundImageView = {
		let imageView = RoundImageView()
		imageView.backgroundColor = .gray30
		
		return imageView
	}()
	
	// MARK: - Initializers
	public init(mode: ProfileImageViewMode) {
		self.mode = mode
		super.init(frame: .zero)
		
		self.setupUI(for: mode)
	}
	
	public convenience init(mode: ProfileImageViewMode, image: UIImage?) {
		self.init(mode: mode)
		profileImageView.image = image
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: - UI Methods
private extension ProfileImageView {
	func setupUI(for mode: ProfileImageViewMode) {
		switch mode {
			case .editable: setupEditableModeUI()
			case .unEditable: setupUnEditableModeUI()
		}
	}
	
	func setupEditableModeUI() {
		setViewHeirarchy()
		setConstraints()
		setupPlusButtonUI()
	}
	
	func setupUnEditableModeUI() {
		setViewHeirarchy()
		setConstraints()
	}
	
	func setViewHeirarchy() {
		addSubview(profileImageView)
	}
	
	func setConstraints() {
		profileImageView.snp.makeConstraints { $0.edges.equalToSuperview() }
	}
	
	func setupPlusButtonUI() {
		let imageView = RoundImageView(image: .iconPlusCircleFill)
		imageView.clipsToBounds = true
		
		addSubviews(imageView)
		
		imageView.snp.makeConstraints { make in
			make.width.height.equalTo(32)
			make.trailing.equalTo(profileImageView).offset(-12)
			make.bottom.equalTo(profileImageView).offset(-4)
		}
	}
}

// MARK: - Reactive Extension
public extension Reactive where Base: ProfileImageView {
	/// 프로필 이미지 선택 Observable
	var didTapImageView: Observable<Void> {
		return base.profileImageView.rx.tapGesture()
			.when(.recognized)
			.map { _ in }
	}
}
