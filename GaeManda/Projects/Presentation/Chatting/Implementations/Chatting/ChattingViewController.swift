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
	BaseViewController,
	ChattingPresentable,
	ChattingViewControllable {
	weak var listener: ChattingPresentableListener?
	
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
	
	private let tableView = UITableView()
	private let chattingTextView = ChattingTextView()
	
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
	
	// MARK: - UI Setting
	func setupUI() {
		setViewHierarchy()
		setConstraints()
		bind()
		optionButtonBind()
		optionsButton.isHidden = true
		scrollView.isScrollEnabled = false
	}
	
	override func setViewHierarchy() {
		super.setViewHierarchy()
		view.addSubview(navigationBar)
		view.addSubview(underLineView)
		view.addSubview(optionsButton)
		
		scrollView.addSubview(contentView)
		contentView.addSubview(tableView)
		contentView.addSubview(chattingTextView)
	}
	
	override func setConstraints() {
		scrollView.snp.makeConstraints { make in
			make.leading.trailing.bottom.equalToSuperview()
			make.top.equalTo(underLineView.snp.bottom)
		}
		
		contentView.snp.makeConstraints { make in
			make.edges.equalTo(scrollView)
			make.width.equalToSuperview()
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
			make.bottom.equalTo(view).offset(-79)
		}

		chattingTextView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.top.equalTo(tableView.snp.bottom)
			make.height.equalTo(79)
		}
	}
	
	// MARK: - Bind
	override func bind() {
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
