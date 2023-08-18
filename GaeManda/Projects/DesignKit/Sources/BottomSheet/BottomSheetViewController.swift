//
//  BottomSheetViewController.swift
//  DesignKit
//
//  Created by 김영균 on 2023/08/07.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import RxCocoa
import RxGesture
import RxSwift
import SnapKit

open class BottomSheetViewController: UIViewController {
	// MARK: - Constants
	private let dimmedAlpha: CGFloat = 0.7
	private let deviceHeight = UIScreen.main.bounds.height
	
	// MARK: - UI Components
	private let contentRootView: UIView = {
		let view = UIView()
		view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
		view.layer.cornerRadius = 9
		view.clipsToBounds = true
		view.backgroundColor = .white
		return view
	}()
	
	fileprivate let dimmedView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor(hexCode: "#4C4C4C", alpha: 0.7)
		return view
	}()
	
	private let contentView: UIView
	
	// MARK: - Initializers
	public init(contentView: UIView) {
		self.contentView = contentView
		super.init(nibName: nil, bundle: nil)
		modalPresentationStyle = .overFullScreen
	}
	
	@available(*, unavailable)
	required public init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Life Cycles
	public override func viewDidLoad() {
		super.viewDidLoad()
		setViewHierarchy()
		setViewConstraints()
	}
	
	public override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		animateDimmdedView()
		animateContainerView()
	}
}

// MARK: - View Methods
private extension BottomSheetViewController {
	func setViewHierarchy() {
		view.addSubview(dimmedView)
		view.addSubview(contentRootView)
		contentRootView.addSubview(contentView)
	}
	
	func setViewConstraints() {
		dimmedView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
		
		contentRootView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.bottom.equalToSuperview().offset(deviceHeight)
		}
		
		contentView.snp.makeConstraints { make in
			make.leading.trailing.equalTo(contentRootView)
			make.top.equalTo(contentRootView.snp.top).offset(24)
			make.bottom.equalTo(contentRootView.snp.bottom).offset(-24)
		}
	}
}

// MARK: - Animation Methods
extension BottomSheetViewController {
	private func animateDimmdedView() {
		dimmedView.alpha = 0
		UIView.animate(withDuration: 0.4) {
			self.dimmedView.alpha = self.dimmedAlpha
		}
	}
	
	private func animateContainerView() {
		UIView.animate(withDuration: 0.4) {
			self.contentRootView.snp.updateConstraints { make in
				make.bottom.equalToSuperview()
			}
			self.view.layoutIfNeeded()
		}
	}
	
	public func animateDismissView() {
		dimmedView.alpha = dimmedAlpha
		UIView.animate(withDuration: 0.4) {
			self.dimmedView.alpha = 0
		} completion: { _ in
			self.dismiss(animated: false)
		}
		
		UIView.animate(withDuration: 0.4) {
			self.contentRootView.snp.updateConstraints { make in
				make.bottom.equalToSuperview().offset(self.deviceHeight)
			}
			self.view.layoutIfNeeded()
		}
	}
}

// MARK: - Reactive Extensions
extension Reactive where Base: BottomSheetViewController {
	public var didTapDimmedView: Observable<Void> {
		base.dimmedView.rx.tapGesture()
			.when(.recognized)
			.throttle(
				.milliseconds(400),
				latest: false,
				scheduler: MainScheduler.instance
			)
			.map { _ in return }
	}
}
