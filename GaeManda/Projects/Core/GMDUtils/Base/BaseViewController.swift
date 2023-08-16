//
//  BaseViewController.swift
//  GMDExtensions
//
//  Created by 김영균 on 2023/08/15.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit

open class BaseViewController: UIViewController {
	// MARK: - Properties
	public let scrollView = UIScrollView()
	public var disposeBag = DisposeBag()
	
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
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(keyboardWillShow),
			name: UIResponder.keyboardWillShowNotification,
			object: nil
		)
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(keyboardWillHide),
			name: UIResponder.keyboardWillHideNotification,
			object: nil
		)
	}
	
	open override func viewDidDisappear(_ animated: Bool) {
		NotificationCenter.default.removeObserver(UIResponder.keyboardWillShowNotification)
		NotificationCenter.default.removeObserver(UIResponder.keyboardWillHideNotification)
	}
	
	// MARK: - Methods
	open func setViewHierarchy() {
		view.addSubview(scrollView)
	}
	
	open func setConstraints() {
		scrollView.snp.makeConstraints {
			$0.edges.equalToSuperview()
		}
	}
	
	open func bind() { }
}

// MARK: - Keyboard
extension BaseViewController {
	@objc func keyboardWillShow(notification: NSNotification) {
		if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
			scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
		}
	}
	
	@objc func keyboardWillHide(notification: NSNotification) {
		scrollView.contentInset = UIEdgeInsets.zero
	}
}
