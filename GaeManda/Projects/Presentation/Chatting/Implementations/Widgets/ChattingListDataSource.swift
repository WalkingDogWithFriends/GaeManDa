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
	var listener: ChattingListPresentableListener? { get set }
	
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
	
	weak var listener: ChattingListPresentableListener?
	
	override init(
		tableView: UITableView,
		cellProvider: @escaping ChattingListDiffableDataSource.CellProvider
	) {
		super.init(tableView: tableView, cellProvider: cellProvider)
		makeSection()
	}
	
	override func tableView(
		_ tableView: UITableView,
		commit editingStyle: UITableViewCell.EditingStyle,
		forRowAt indexPath: IndexPath
	) {
		guard editingStyle == .delete else { return }
		guard let item = itemIdentifier(for: indexPath) else { return }
		Task { @MainActor [weak self] in
			await self?.listener?.deleteChatting(at: item.roomId)
			self?.deleteChatting(at: indexPath)
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { tableView.setEditing(false, animated: true) }
		}
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
	
	func deleteChatting(at indexPath: IndexPath) {
		var snapshot = snapshot()
		guard let item = itemIdentifier(for: indexPath) else { return }
		snapshot.deleteItems([item])
		apply(snapshot, animatingDifferences: true)
	}
}

private extension ChattingListDataSource {
	func makeSection() {
		var snapshot = ChattingListSnapShot()
		snapshot.appendSections([.chattingList])
		apply(snapshot, animatingDifferences: true)
	}
}
