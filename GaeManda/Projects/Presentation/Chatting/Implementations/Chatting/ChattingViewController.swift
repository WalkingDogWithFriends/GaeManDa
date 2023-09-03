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
	func didTapOffAlarm()
	func didTapLeaveChatting()
}

final class ChattingViewController:
	UIViewController,
	ChattingPresentable,
	ChattingViewControllable {
	weak var listener: ChattingPresentableListener?
	private let disposeBag = DisposeBag()
	var keyboardShowNotification: NSObjectProtocol?
	var keyboardHideNotification: NSObjectProtocol?
	
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
	
	private let contentView = UIView()
	
	/// display when the use click navigation right Button
	private let optionsButton = ChattingOptionsButton()
	
	private let tableView: UITableView = {
		let tableView = UITableView()
		tableView.registerCell(DateCell.self)
		tableView.registerCell(ReceiveCell.self)
		tableView.registerCell(ReceiveWithProfileImageCell.self)
		tableView.registerCell(SendCell.self)

		tableView.showsVerticalScrollIndicator = false
		tableView.rowHeight = UITableView.automaticDimension
		tableView.separatorStyle = .none
		tableView.separatorColor = .clear
		
		return tableView
	}()

	private let chattingTextView = ChattingTextView()
	
	// MARK: - Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		self.keyboardShowNotification = registerKeyboardShowNotification()
		self.keyboardHideNotification = registerKeyboardHideNotification()
		view.backgroundColor = .gray20
		navigationBar.titleLabel.font = .r16
		setupUI()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		hideTabBar()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		removeKeyboardNotification([keyboardShowNotification, keyboardHideNotification])
	}
}
// MARK: - UI Setting

private extension ChattingViewController {
	func setupUI() {
		setViewHierarchy()
		setConstraints()
		bind()
		optionButtonBind()
		chattingTextViewBind()
		optionsButton.isHidden = true
		scrollToBottom()
	}
	
	func setViewHierarchy() {
		view.addSubviews(navigationBar, underLineView, contentView, optionsButton)
		
		contentView.addSubviews(tableView, chattingTextView)
	}
	
	func setConstraints() {
		contentView.snp.makeConstraints { make in
			make.leading.trailing.bottom.equalToSuperview()
			make.top.equalTo(underLineView.snp.bottom)
		}
		
		navigationBar.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
			make.height.equalTo(44)
		}
		
		underLineView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.top.equalTo(navigationBar.snp.bottom)
			make.height.equalTo(1)
		}
		
		optionsButton.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(60)
			make.trailing.equalToSuperview().offset(-22)
			make.top.equalToSuperview().offset(122)
		}
		
		tableView.snp.makeConstraints { make in
			make.leading.trailing.top.equalToSuperview()
			make.bottom.equalTo(chattingTextView.snp.top)
		}
		
		chattingTextView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.bottom.equalTo(contentView.safeAreaLayoutGuide)
		}
	}
}

// MARK: - Bind
private extension ChattingViewController {
	func bind() {
		navigationBar.backButton.rx.tap
			.bind(with: self) { owner, _ in
				owner.listener?.didTapBackButton()
			}
			.disposed(by: disposeBag)
		
		navigationBar.rightItems?.first?.rx.tap
			.bind(with: self) { owner, _ in
				owner.optionsButton.isHidden = false
			}
			.disposed(by: disposeBag)
	}
	
	/// when click option Button
	func optionButtonBind() {
		/// when option Button display and tap backGround, dismiss optionsButton
		view.rx.tapGesture()
			.when(.recognized)
			.throttle(
				.milliseconds(400),
				latest: false,
				scheduler: MainScheduler.instance
			)
			.bind(with: self) { owner, _ in
				owner.chattingTextView.endEditing(true)
				guard owner.optionsButton.isHidden == false else { return }
				owner.optionsButton.isHidden = true
			}
			.disposed(by: disposeBag)
		
		optionsButton.rx.offAlarmButtonDidTapped
			.bind(with: self) { owner, _ in
				owner.listener?.didTapOffAlarm()
				owner.optionsButton.isHidden = true
			}
			.disposed(by: disposeBag)
		
		optionsButton.rx.leaveChattingButtonDidTapped
			.bind(with: self) { owner, _ in
				owner.displayLeaveChattingAlertController()
				owner.optionsButton.isHidden = true
			}
			.disposed(by: disposeBag)
	}
	
	func chattingTextViewBind() {
		chattingTextView.rx.text
			.orEmpty
			.map { $0.isEmpty }
			.bind(with: self) { owner, isEmpty in
				owner.chattingTextView.buttonIsHidden = isEmpty
			}
			.disposed(by: disposeBag)
	}
}

// MARK: - AlertController
private extension ChattingViewController {
	func displayLeaveChattingAlertController() {
		let alert = UIAlertController(
			title: "채팅방 나가기",
			message: "나가기를 하면 대화내용이 모두 삭제되고 채팅 목록에서도 삭제됩니다.",
			preferredStyle: .alert
		)
		
		let cancel = UIAlertAction(title: "취소", style: .default)
		let confirm = UIAlertAction(title: "나가기", style: .destructive) { [weak self] _ in
			self?.listener?.didTapLeaveChatting()
		}
		
		alert.addAction(cancel)
		alert.addAction(confirm)
		
		present(alert, animated: true)
	}
}

// MARK: - KeyboardListener
extension ChattingViewController: KeyboardListener {
	func keyboardWillShow(height: CGFloat) {
		UIView.animate(withDuration: 0.3) {
			self.contentView.snp.updateConstraints { make in
				make.bottom.equalToSuperview().offset(-height)
			}
			self.view.layoutIfNeeded()
		}
		scrollToBottom()
	}
	
	func keyboardWillHide() {
		UIView.animate(withDuration: 0.3) {
			self.contentView.snp.updateConstraints { make in
				make.bottom.equalToSuperview()
			}
			self.view.layoutIfNeeded()
		}
	}
}

// MARK: - TableView
private extension ChattingViewController {
	func scrollToBottom() {
		let count = tableView.numberOfRows(inSection: 0)
		guard count > 0 else { return }
		let lastIndexPath = IndexPath(row: count - 1, section: 0)

		DispatchQueue.main.async { [weak self] in
			self?.tableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: true)
		}
	}
}
