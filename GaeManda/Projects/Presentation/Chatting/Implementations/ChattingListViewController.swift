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

protocol ChattingListPresentableListener: AnyObject { }

final class ChattingListViewController:
	UIViewController,
	ChattingListPresentable,
	ChattingListViewControllable {
	weak var listener: ChattingListPresentableListener?
	private let disposeBag = DisposeBag()
	
	// MARK: UI Components
	private let chattingListTableView: UITableView = {
		let tableView = UITableView()
		tableView.register(
			ChattingListCell.self,
			forCellReuseIdentifier: ChattingListCell.identifier
		)

		return tableView
	}()
	
	private let refreshControl: UIRefreshControl = {
		let refreshControl = UIRefreshControl()
		refreshControl.attributedTitle = .init(string: "새로 고침")
		
		return refreshControl
	}()
	
	// MARK: Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupUI()
	}
}

// MARK: UI Setting
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
		view.addSubview(chattingListTableView)
	}
	
	func setConstraints() {
		chattingListTableView.snp.makeConstraints { make in
			make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
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
