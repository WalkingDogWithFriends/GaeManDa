//
//  ChattingListViewController.swift
//  ChattingImpl
//
//  Created by jung on 2023/08/16.
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

protocol ChattingListPresentableListener: AnyObject {
	func didTapChatting(with user: String)
}

final class ChattingListViewController:
	UIViewController,
	ChattingListPresentable,
	ChattingListViewControllable {
	weak var listener: ChattingListPresentableListener?
	private let disposeBag = DisposeBag()
	
	// MARK: - UI Components
	private let navigationBar: GMDNavigationBar = {
		let navigationBar = GMDNavigationBar(title: "채팅")
		navigationBar.backButton.isHidden = true
		
		return navigationBar
	}()
	
	private let chattingListTableView: UITableView = {
		let tableView = UITableView()
		tableView.registerCell(ChattingListCell.self)
		// remove Top Seperator
		tableView.tableHeaderView = UIView()

		return tableView
	}()
	
	private let refreshControl: UIRefreshControl = {
		let refreshControl = UIRefreshControl()
		refreshControl.attributedTitle = .init(string: "새로 고침")
		
		return refreshControl
	}()
	
	// MARK: - Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationController?.navigationBar.isHidden = true
		
		setupUI()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		showTabBar()
	}
}

// MARK: - UI Setting
private extension ChattingListViewController {
	func setupUI() {
		title = "채팅"
		setNavigationTitleFont(.b20)
		
		// Register RefreshControl
		chattingListTableView.refreshControl = refreshControl
		
		setupSubviews()
		setConstraints()
		bind()
	}
	
	func setupSubviews() {
		view.addSubview(navigationBar)
		view.addSubview(chattingListTableView)
	}
	
	func setConstraints() {
		navigationBar.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
			make.height.equalTo(44)
		}
		
		chattingListTableView.snp.makeConstraints { make in
			make.top.equalTo(navigationBar.snp.bottom)
			make.leading.trailing.equalToSuperview()
			make.bottom.equalToSuperview().offset(152)
		}
	}
	
	func bind() {
		/// Refresh Control
		refreshControl.rx.controlEvent(.valueChanged)
			.subscribe(with: self) { owner, _ in
				DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
					owner.chattingListTableView.reloadData()
					owner.refreshControl.endRefreshing()
				}
			}
			.disposed(by: disposeBag)
	}
}
