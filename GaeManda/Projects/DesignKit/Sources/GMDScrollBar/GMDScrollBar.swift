//
//  GMDScrollBar.swift
//  DesignKit
//
//  Created by jung on 12/5/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

public final class GMDScrollBar: UIControl {
	// MARK: - Properties
	private var leadingInsetConstraint: Constraint?
	
	/// 보이는 Content의 width (view의 size)
	public var visibleWidth: CGFloat = 0
	
	/// 전체 Content의 width
	public var contentWidth: CGFloat = 0 {
		didSet {
			self.sendActions(for: .valueChanged)
			setIndicatorViewWidth(visibleWidth: visibleWidth, contentWidth: contentWidth)
		}
	}
	
	/// 현재 Content의 x offset
	public var contentOffSetX: CGFloat = 0 {
		didSet {
			setLeadingOffSet(contentOffSetX: contentOffSetX, contentWidth: contentWidth)
		}
	}
	
	private var indicatorViewWidth: CGFloat = 0.0 {
		didSet { updateIndicatorViewWidth(indicatorViewWidth) }
	}
	
	/// IndicatorView의 leading OffSet
	private var indicatorViewLeadingOffSet: CGFloat = 0.0 {
		didSet { updateIndicatorViewLeadingOffSet(indicatorViewLeadingOffSet) }
	}
	
	/// Scroll Bar 조작을 통해 offset이동시 방출하는 Observable
	public var contentOffSetXDidMove = BehaviorRelay<CGFloat>(value: .zero)
	
	public override var isSelected: Bool {
		didSet {
			self.indicatorView.backgroundColor = self.isSelected ? .gray90 : .gray60
		}
	}
	
	private var previousTouchPoint: CGPoint = .zero
	
	// MARK: - UI Components
	private let containerView: UIView = {
		let view = UIView()
		view.isUserInteractionEnabled = false
		view.backgroundColor = .gray40
		view.layer.cornerRadius = 5
		
		return view
	}()
	
	fileprivate let indicatorView: UIView = {
		let view = UIView()
		view.isUserInteractionEnabled = false
		view.backgroundColor = .gray60
		view.layer.cornerRadius = 5
		
		return view
	}()
	
	// MARK: - Initializers
	public init() {
		super.init(frame: .zero)
		setupUI()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Override Method
	public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
		// indicatorView에서 touch가 발생했는지 확인
		return self.indicatorView.frame.contains(point)
	}
	
	public override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
		self.previousTouchPoint = touch.location(in: self)
		self.isSelected = true
		
		return true
	}
	
	public override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
		let touchPoint = touch.location(in: self)
		
		defer { self.previousTouchPoint = touchPoint }
		
		let drag = Double(touchPoint.x - self.previousTouchPoint.x)
		let scale = visibleWidth
		let dragScale = scale * drag / Double(self.bounds.width - indicatorViewWidth)
		
		if contentOffSetX + dragScale < 0 {
			contentOffSetX = 0
		} else if contentWidth - visibleWidth < contentOffSetX + dragScale {
			contentOffSetX = contentWidth - visibleWidth
		} else {
			contentOffSetX += dragScale
		}
		
		contentOffSetXDidMove.accept(contentOffSetX)
		
		return true
	}
	
	public override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
		self.isSelected = false
	}
}

// MARK: - UI Methods
private extension GMDScrollBar {
	func setupUI() {
		self.backgroundColor = .gray40
		self.layer.cornerRadius = 5
		
		setViewHeirarchy()
		setConstraints()
	}
	
	func setViewHeirarchy() {
		addSubview(containerView)
		containerView.addSubview(indicatorView)
	}
	
	func setConstraints() {
		containerView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
		
		indicatorView.snp.makeConstraints { make in
			make.top.bottom.equalToSuperview()
			make.width.equalTo(self.bounds.width)
			
			make.leading.greaterThanOrEqualToSuperview()
			make.trailing.lessThanOrEqualToSuperview()
			
			self.leadingInsetConstraint = make.leading.equalToSuperview().priority(999).constraint
		}
	}
}

// MARK: - Update Methods
private extension GMDScrollBar {
	func setIndicatorViewWidth(visibleWidth: CGFloat, contentWidth: CGFloat) {
		guard contentWidth != 0 else { return }
		
		let ratio = visibleWidth / contentWidth
		
		// Content 내비 현재 영역의 비율
		let widthRatio = ratio >= 1.0 ? 1.0: ratio
		self.indicatorViewWidth = bounds.width * widthRatio
	}
	
	func setLeadingOffSet(contentOffSetX: CGFloat, contentWidth: CGFloat) {
		guard contentWidth != 0 else { return }
		
		let leftRatio = contentOffSetX / contentWidth
		self.indicatorViewLeadingOffSet = contentOffSetX / contentWidth * bounds.width
	}
	
	func updateIndicatorViewWidth(_ width: Double) {
		indicatorView.snp.updateConstraints { make in
			make.width.equalTo(width)
		}
	}
	
	func updateIndicatorViewLeadingOffSet(_ offSet: Double) {
		DispatchQueue.main.async {
			self.leadingInsetConstraint?.update(offset: offSet)
		}
	}
}

// MARK: - Reactive Extension
public extension Reactive where Base: GMDScrollBar {
	var contentOffSetX: ControlProperty<CGFloat> {
		return controlProperty(
			editingEvents: [.valueChanged],
			getter: { view in
				view.contentOffSetX
			},
			setter: { view, contentOffSetX in
				view.contentOffSetX = contentOffSetX
			}
		)
	}
	
	var contentWidth: ControlProperty<CGFloat> {
		return controlProperty(
			editingEvents: [.valueChanged],
			getter: { view in
				view.contentWidth
			},
			setter: { view, contentWidth in
				view.contentWidth = contentWidth
			}
		)
	}
	
	var isScrollable: ControlEvent<Bool> {
		let source = contentWidth.asObservable()
			.map { width -> Bool in
				return width != 0 && width > base.visibleWidth
			}
		
		return ControlEvent(events: source)
	}
}
