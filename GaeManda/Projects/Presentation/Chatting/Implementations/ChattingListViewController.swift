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
	func viewWillAppear()
	func didTapChatting(with user: String)
}

final class ChattingListViewController:
	UIViewController,
	ChattingListViewControllable {
	weak var listener: ChattingListPresentableListener?
	private let disposeBag = DisposeBag()
	
	// MARK: - UI Components
	private let navigationBar: GMDNavigationBar = {
		let navigationBar = GMDNavigationBar(title: "채팅", rightItems: [.more])
		navigationBar.backButton.isHidden = true
		
		return navigationBar
	}()
	
	private let chattingListTableView: UITableView = {
		let tableView = UITableView()
		tableView.registerCell(ChattingListCell.self)
		tableView.estimatedRowHeight = 84
		tableView.rowHeight = 84
		return tableView
	}()
	
	private var chattingListDataSource: (ChattingListDiffableDataSource & ChattingListDataSourceProtocol)?
	
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
		listener?.viewWillAppear()
	}
}

// MARK: - UI Setting
private extension ChattingListViewController {
	func setupUI() {
		// Register RefreshControl
		chattingListTableView.refreshControl = refreshControl
		setViewAttributes()
		setupSubviews()
		setConstraints()
		bind()
	}
	
	func setupSubviews() {
		view.addSubviews(navigationBar, chattingListTableView)
	}
	
	func setViewAttributes() {
		chattingListDataSource = ChattingListDataSource(
			tableView: chattingListTableView,
			cellProvider: { tableView, indexPath, itemIdentifier in
				let cell = tableView.dequeueCell(ChattingListCell.self, for: indexPath)
				cell.configure(with: itemIdentifier)
				return cell
			}
		)
		navigationBar.rightItems?.first?.menu = makeNavigationBarRightButtonMenu()
		navigationBar.rightItems?.first?.showsMenuAsPrimaryAction = true
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
			make.bottom.equalToSuperview().offset(-152)
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
	
	func makeNavigationBarRightButtonMenu() -> UIMenu {
		let editAction = UIAction(title: "편집") { _ in
		}
		let allChattingMuteAction = UIAction(title: "채팅 알림 전체 끄기") { _ in			
		}
		return UIMenu(title: "", children: [allChattingMuteAction, editAction])
	}
}

extension ChattingListViewController: ChattingListPresentable {
	func updateChattingList(_ chattingList: [ChattingListDataSource.ViewModel]) {
		chattingListDataSource?.updateChattingList(chattingList)
	}
}
