//
//  ChattingViewController.swift
//  Chatting
//
//  Created by jung on 2023/08/18.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import RIBs
import RxCocoa
import RxSwift
import SnapKit
import DesignKit
import GMDExtensions
import GMDUtils

protocol ChattingPresentableListener: AnyObject {
	func didTapBackButton()
}

final class ChattingViewController:
	UIViewController,
	ChattingPresentable,
	ChattingViewControllable {
	weak var listener: ChattingPresentableListener?
	private let disposeBag = DisposeBag()
	
	// MARK: - UI Components
	private lazy var navigationBar = GMDNavigationBar(
		title: "윈터",
		rightItems: [.setting]
	)
	
	/// view located navigation Bar bottom
	private let underLineView: UIView = {
		let view = UIView()
		view.backgroundColor = .gray50
		
		return view
	}()
	
	private let tableView = UITableView()
	
	// MARK: - Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationBar.titleLabel.font = .r16
		setupUI()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		hideTabBar()
	}
}

// MARK: - Setting UI
private extension ChattingViewController {
	func setupUI() {
		setupSubViews()
		setConstraints()
		bind()
	}
	
	func setupSubViews() {
		view.addSubviews(navigationBar, underLineView)
	}
	
	func setConstraints() {
		navigationBar.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
			make.height.equalTo(44)
		}
		
		underLineView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.top.equalTo(navigationBar.snp.bottom)
			make.height.equalTo(1)
		}	}
}

// MARK: - Bind
private extension ChattingViewController {
	func bind() {
		navigationBar.backButton.rx.tap
			.bind(with: self) { owner, _ in
				owner.listener?.didTapBackButton()
			}
			.disposed(by: disposeBag)
	}
}
