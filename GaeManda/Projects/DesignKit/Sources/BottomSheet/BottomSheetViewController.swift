//
//  BottomSheetViewController.swift
//  DesignKit
//
//  Created by 김영균 on 2023/08/07.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture
import SnapKit

open class BottomSheetViewController: UIViewController {
	// MARK: - UI Components
	private lazy var contentRootView: UIView = {
		let view = UIView()
		view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
		view.layer.cornerRadius = 9
		view.clipsToBounds = true
		view.backgroundColor = .white
		return view
	}()
	
	fileprivate lazy var dimmedView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor.gray30.withAlphaComponent(0.7)
		return view
	}()
	
	private let contentView: UIView
	
	// MARK: Initializers
	public init(contentView: UIView) {
		self.contentView = contentView
		super.init(nibName: nil, bundle: nil)
		modalPresentationStyle = .overFullScreen
	}
	
	required public init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Life Cycles
	public override func viewDidLoad() {
		super.viewDidLoad()
		configureLayouts()
	}
}

// MARK: Private Methods
private extension BottomSheetViewController {
	 func configureLayouts() {
		view.addSubview(dimmedView)
		view.addSubview(contentRootView)
		
		dimmedView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
		
		contentRootView.snp.makeConstraints { make in
			make.leading.trailing.bottom.equalToSuperview()
		}
		
		contentView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.top.equalTo(contentRootView.snp.top).offset(20)
			make.bottom.equalTo(contentRootView.snp.bottom).offset(-20)
		}
	}
}

// MARK: Reactive Extensions
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
