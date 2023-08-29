//
//  BaseViewController.swift
//  GMDExtensions
//
//  Created by 김영균 on 2023/08/15.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import RxGesture
import RxSwift
import SnapKit

open class BaseViewController: UIViewController {
	// MARK: - Properties
	public var disposeBag = DisposeBag()
	
	// MARK: - UI Components
	private let scrollView: UIScrollView = {
		let scrollView = UIScrollView()
		scrollView.showsVerticalScrollIndicator = false
		scrollView.showsHorizontalScrollIndicator = false
		return scrollView
	}()
	
	public let contentView = UIView()
	
	// MARK: - Initializers
	public init() {
		super.init(nibName: nil, bundle: nil)
	}
	
	required public init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Life Cycles
	open override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = .white
		registerKeyboardNotification()
		// bind
		contentView.rx.tapGesture()
			.when(.recognized)
			.bind(with: self) { owner, _ in
				owner.view.endEditing(true)
			}
			.disposed(by: disposeBag)
	}
	
	open override func viewDidDisappear(_ animated: Bool) {
		removeKeyboardNotification()
	}
	
	// MARK: - Methods
	open func setViewHierarchy() {
		view.addSubview(scrollView)
		scrollView.addSubview(contentView)
	}
	
	open func setConstraints() {
		scrollView.snp.makeConstraints { make in
			make.top.equalTo(view.safeAreaLayoutGuide)
			make.leading.trailing.bottom.equalToSuperview()
		}
		contentView.snp.makeConstraints { make in
			make.edges.width.equalTo(scrollView)
		}
	}
	
	open func bind() { }
}

// MARK: - Keyboard
extension BaseViewController: KeyboardListener {
	public func keyboardWillShow(height: CGFloat) {
		scrollView.contentInset.bottom = height
	}
	
	public func keyboardWillHide() {
		scrollView.contentInset = UIEdgeInsets.zero
	}
}
