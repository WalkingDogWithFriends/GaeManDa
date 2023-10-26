//
//  BottomSheetViewController.swift
//  DesignKit
//
//  Created by 김영균 on 2023/08/07.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import RxRelay
import SnapKit
import GMDExtensions

open class BottomSheetViewController: UIViewController {
	// MARK: - Constants
	private var minTopSpacing: CGFloat = 80
	
	// MARK: - Properties
	private let mainContainerView: UIView = {
		let view = UIView()
		view.backgroundColor = .white
		view.layer.cornerRadius = 8
		view.clipsToBounds = true
		
		return view
	}()
	
	open var contentView = UIView()
	
	private let topBarView: UIView = {
		let view = UIView()
		view.backgroundColor = .white
		
		return view
	}()
	
	fileprivate let dimmedView: UIView = {
		let view = UIView()
		view.backgroundColor = .dimmedColor
		return view
	}()
	
	public var didDismissBottomSheet = PublishRelay<Void>()
	
	// MARK: - View Life Cycle
	open override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		setupGestures()
	}
	
	open override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		animatePresent()
	}
	
	// MARK: - UI Methods
	private func setupUI() {
		view.backgroundColor = .clear
		setViewHierarchy()
		setConstraints()
	}
	
	private func setViewHierarchy() {
		view.addSubviews(dimmedView, mainContainerView)
		mainContainerView.addSubviews(topBarView, contentView)
	}
	
	private func setConstraints() {
		dimmedView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
		
		mainContainerView.snp.makeConstraints { make in
			make.top.greaterThanOrEqualTo(view).offset(minTopSpacing)
			make.leading.trailing.bottom.equalTo(view)
		}
		
		topBarView.snp.makeConstraints { make in
			make.top.leading.trailing.equalToSuperview()
			make.height.equalTo(36)
		}
		
		contentView.snp.makeConstraints { make in
			make.top.equalTo(topBarView.snp.bottom)
			make.leading.equalToSuperview().offset(24)
			make.bottom.equalToSuperview().offset(-24)
			make.trailing.equalToSuperview().offset(-24)
		}
	}
	
	private func setupGestures() {
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapDimmedView))
		dimmedView.addGestureRecognizer(tapGesture)
		
		let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPanTopView))
		topBarView.addGestureRecognizer(panGesture)
	}
	
	@objc private func didTapDimmedView() {
		dismissBottomSheet()
	}
	
	@objc fileprivate func didPanTopView(_ gesture: UIPanGestureRecognizer) {
		let translation = gesture.translation(in: view)
		let isDraggingDown = translation.y > 0
		guard isDraggingDown else { return }
		
		let pannedHeight = translation.y
		let currentY = self.view.frame.height - self.mainContainerView.frame.height
		
		switch gesture.state {
		case .changed:
				self.mainContainerView.frame.origin.y = currentY + pannedHeight
		case .ended:
				let shouldDismiss = pannedHeight > self.mainContainerView.frame.height / 2
				if shouldDismiss {
					dismissBottomSheet()
				} else {
					self.mainContainerView.frame.origin.y = currentY
				}
				
		default:
				break
		}
	}
	
	open func dismissBottomSheet() {
		UIView.animate(withDuration: 0.3) {
			self.dimmedView.alpha = 0.7
			self.mainContainerView.frame.origin.y = self.view.frame.height
		} completion: { _ in
			self.dismiss(animated: false)
			self.didDismissBottomSheet.accept(())
		}
	}
	
	private func animatePresent() {
		dimmedView.alpha = 0
		mainContainerView.transform = CGAffineTransform(translationX: 0, y: view.frame.height)
		UIView.animate(withDuration: 0.3) {
			self.mainContainerView.transform = .identity
		}
		
		UIView.animate(withDuration: 0.3) {
			self.dimmedView.alpha = 0.7
		}
	}
}
