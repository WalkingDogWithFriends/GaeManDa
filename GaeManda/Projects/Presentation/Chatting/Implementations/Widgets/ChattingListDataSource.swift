//
//  ChattingListDataSource.swift
//  ChattingImpl
//
//  Created by 김영균 on 12/20/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit

typealias ChattingListDiffableDataSource = UITableViewDiffableDataSource<
	ChattingListDataSource.Section,
	ChattingListDataSource.ViewModel
>
typealias ChattingListSnapShot = NSDiffableDataSourceSnapshot<
	ChattingListDataSource.Section,
	ChattingListDataSource.ViewModel
>

protocol ChattingListDataSourceProtocol: AnyObject {
	func updateChattingList(_ chattingList: [ChattingListDataSource.ViewModel])
	func chatting(for indexPath: IndexPath) -> ChattingListDataSource.ViewModel?
}

final class ChattingListDataSource: ChattingListDiffableDataSource {
	enum Section { case chattingList }
	
	struct ViewModel: Hashable {
		private var id: Int { roomId }
		let roomId: Int
		let nickName: String
		let profileImage: String
		let message: String
		let newMessageCount: Int?
		let recentMessageDate: String
	}
	
	override init(
		tableView: UITableView,
		cellProvider: @escaping ChattingListDiffableDataSource.CellProvider
	) {
		super.init(tableView: tableView, cellProvider: cellProvider)
		makeSection()
	}
}

extension ChattingListDataSource: ChattingListDataSourceProtocol {
	func updateChattingList(_ chattingList: [ChattingListDataSource.ViewModel]) {
		var snapshot = ChattingListSnapShot()
		snapshot.appendSections([.chattingList])
		snapshot.appendItems(chattingList)
		apply(snapshot, animatingDifferences: true)
	}
	
	func chatting(for indexPath: IndexPath) -> ViewModel? {
		return itemIdentifier(for: indexPath)
	}
}

private extension ChattingListDataSource {
	func makeSection() {
		var snapshot = ChattingListSnapShot()
		snapshot.appendSections([.chattingList])
		apply(snapshot, animatingDifferences: true)
	}
}
