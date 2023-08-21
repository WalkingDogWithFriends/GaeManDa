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
		addKeyboardObserver()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		hideTabBar()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		removeKeyboardObserver()
	}
}
// MARK: - UI Setting

private extension ChattingViewController {
	func setupUI() {
		setViewHierarchy()
		setConstraints()
		bind()
		optionButtonBind()
		optionsButton.isHidden = true
	}
	
	func setViewHierarchy() {
		view.addSubview(navigationBar)
		view.addSubview(underLineView)
		view.addSubview(contentView)
		view.addSubview(optionsButton)
		
		contentView.addSubview(tableView)
		contentView.addSubview(chattingTextView)
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
			make.leading.trailing.bottom.equalToSuperview()
			make.height.equalTo(79)
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

// MARK: Keyboard Respond
private extension ChattingViewController {
	func addKeyboardObserver() {
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
	
	func removeKeyboardObserver() {
		NotificationCenter.default.removeObserver(UIResponder.keyboardWillShowNotification)
		NotificationCenter.default.removeObserver(UIResponder.keyboardWillHideNotification)
	}
	
	@objc func keyboardWillShow(_ notification: Notification) {
		guard let userInfo = notification.userInfo,
					let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
		else {
			return
		}
		let offset = keyboardSize.height - 22
		contentView.snp.updateConstraints { make in
			make.bottom.equalToSuperview().offset(-offset)
		}
		contentView.layoutSubviews()
	}
	
	@objc func keyboardWillHide() {
		contentView.snp.updateConstraints { make in
			make.bottom.equalToSuperview()
		}
	}
}
