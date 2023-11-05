//
//  DetailAddressSettingViewController.swift
//  OnBoarding
//
//  Created by jung on 2023/07/08.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import WebKit
import RIBs
import RxCocoa
import RxSwift
import SnapKit
import DesignKit
import GMDExtensions
import GMDUtils
import NMapsGeometry

protocol DetailAddressSettingPresentableListener: AnyObject {
	func detailAddressSettingDidDismiss()
	func closeButtonDidTap()
	func loadLocationButtonDidTap(jibunAddress: String)
}

final class DetailAddressSettingViewController:
	UIViewController,
	DetailAddressSettingPresentable,
	DetailAddressSettingViewControllable {
	// MARK: - Properties
	weak var listener: DetailAddressSettingPresentableListener?
	private let disposeBag = DisposeBag()
	
	private let titleLabel: UILabel = {
		let label = UILabel()
		label.text = "주소 검색"
		label.font = .b16
		
		return label
	}()
	
	private let closeButton: UIButton = {
		let button = UIButton()
		let image = UIImage.iconCloseRound
		button.setImage(image, for: .normal)
		button.tintColor = .black
		
		return button
	}()
	
	private lazy var webView: WKWebView = {
		let userContentController = WKUserContentController()
		userContentController.add(MessageHandler(delegate: self), name: "callBackHandler")
		let configuration = WKWebViewConfiguration()
		configuration.userContentController = userContentController
		let webView = WKWebView(frame: self.view.bounds, configuration: configuration)
		
		return webView
	}()
	
	// MARK: - View LifeCycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setUI()
		loadWebView()
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		listener?.detailAddressSettingDidDismiss()
	}
}

private extension DetailAddressSettingViewController {
	func setUI() {
		self.view.backgroundColor = .white
		setViewHierarchy()
		setConstraints()
		bind()
	}
	
	func setViewHierarchy() {
		view.addSubviews(titleLabel, closeButton, webView)
	}
	
	func setConstraints() {
		titleLabel.snp.makeConstraints {
			$0.top.equalTo(view).offset(24)
			$0.leading.equalToSuperview().offset(16)
		}
		
		closeButton.snp.makeConstraints {
			$0.centerY.equalTo(titleLabel)
			$0.trailing.equalToSuperview().offset(-12)
		}
		
		webView.snp.makeConstraints {
			$0.top.equalTo(titleLabel.snp.bottom).offset(8)
			$0.leading.trailing.equalToSuperview()
			$0.bottom.equalToSuperview().offset(32)
		}
	}
	
	func bind() {
		closeButton.rx.tap
			.bind(with: self, onNext: { owner, _ in
				owner.listener?.closeButtonDidTap()
			})
			.disposed(by: disposeBag)	
	}
	
	func loadWebView() {
		guard let url = URL(string: "https://walkingdogwithfriends.github.io/kakao-postcode/") else { return }
		let request = URLRequest(url: url)
		webView.load(request)
	}
}

extension DetailAddressSettingViewController: WKScriptMessageHandler {
	func userContentController(
		_ userContentController: WKUserContentController,
		didReceive message: WKScriptMessage
	) {
		guard
			let body = message.body as? [String: Any],
			let jibunAddress = body["jibunAddress"] as? String,
			let roadAddress = body["roadAddress"] as? String,
			let zoneCode = body["zonecode"] as? String
		else { return }
		print(jibunAddress, roadAddress, zoneCode)
		listener?.loadLocationButtonDidTap(jibunAddress: jibunAddress)
	}
}

fileprivate extension DetailAddressSettingViewController {
	class MessageHandler: NSObject, WKScriptMessageHandler {
		weak var delegate: WKScriptMessageHandler?
		
		init(delegate: WKScriptMessageHandler) {
			self.delegate = delegate
			super.init()
		}
		
		func userContentController(
			_ userContentController: WKUserContentController,
			didReceive message: WKScriptMessage
		) {
			self.delegate?.userContentController(userContentController, didReceive: message)
		}
	}
}
