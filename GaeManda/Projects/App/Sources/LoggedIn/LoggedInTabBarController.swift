//
//  LoggedInViewController.swift
//  Dev-GaeManda
//
//  Created by jung on 2023/07/17.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import RIBs
import RxSwift
import RxGesture
import DesignKit
import GMDUtils

protocol LoggedInPresentableListener: AnyObject { }

final class LoggedInTabBarController:
	UIViewController,
	LoggedInPresentable,
	LoggedInViewControllable {
	weak var listener: LoggedInPresentableListener?
	private let disposeBag = DisposeBag()

	private var selectedIndex: Int = 0
	private lazy var tabBarButtons = [firstTabButton, secondTabButton, thirdTabButton]
	private var tabViewControllers = [UIViewController]()
	
	private let floatingTabBar: UIView = {
		let view = UIView()
		view.backgroundColor = .gray20
		view.layer.cornerRadius = 20
		
		return view
	}()
	
	private let firstTabButton: TabBarButton = {
		let image = UIImage(
			systemName: "pawprint",
			withConfiguration: UIImage.SymbolConfiguration(pointSize: 20)
		)
		let button = TabBarButton(image: image, title: "산책")
		button.tag = 0
		
		return button
	}()
	
	private let secondTabButton: TabBarButton = {
		let image = UIImage(
			systemName: "pawprint",
			withConfiguration: UIImage.SymbolConfiguration(pointSize: 54)
		)
		
		let roundImageView = RoundImageView(image: image)
		roundImageView.backgroundColor = .white
		let button = TabBarButton(imageView: roundImageView, title: "프로필")
		button.tag = 1
		
		return button
	}()
	
	private let thirdTabButton: TabBarButton = {
		let image = UIImage(
			systemName: "pawprint",
			withConfiguration: UIImage.SymbolConfiguration(pointSize: 20)
		)
		let button = TabBarButton(image: image, title: "채팅")
		button.tag = 2
		
		return button
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupUI()
		
		attachViewControllerToParent(0)
	}
	
	private func setupUI() {
		setupSubviews()
		setConstraints()
		bind()
	}
	
	private func setupSubviews() {
		view.backgroundColor = .white
		
		view.addSubview(floatingTabBar)
		floatingTabBar.addSubview(firstTabButton)
		floatingTabBar.addSubview(secondTabButton)
		floatingTabBar.addSubview(thirdTabButton)
	}
	
	private func setConstraints() {
		NSLayoutConstraint.activate([
			floatingTabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 21),
			floatingTabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -21),
			floatingTabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32),
			floatingTabBar.heightAnchor.constraint(equalToConstant: 60),
			
			firstTabButton.leadingAnchor.constraint(equalTo: floatingTabBar.leadingAnchor, constant: 26),
			firstTabButton.centerYAnchor.constraint(equalTo: floatingTabBar.centerYAnchor),
			
			secondTabButton.centerXAnchor.constraint(equalTo: floatingTabBar.centerXAnchor),
			secondTabButton.bottomAnchor.constraint(equalTo: firstTabButton.bottomAnchor),
			
			thirdTabButton.trailingAnchor.constraint(equalTo: floatingTabBar.trailingAnchor, constant: -21),
			thirdTabButton.centerYAnchor.constraint(equalTo: floatingTabBar.centerYAnchor)
		])
	}
	
	private func bind() {
		tabBarButtons.forEach { button in
			button.rx.tapGesture()
				.when(.recognized)
				.withUnretained(self)
				.bind { owner, _ in
					owner.didTapTapBarButton(button)
				}
				.disposed(by: disposeBag)
		}
	}
	
	func setViewControllers(_ viewControllers: [ViewControllable]) {
		viewControllers
			.map(\.uiviewController)
			.forEach { [weak self] viewController in
				self?.tabViewControllers.append(viewController)
			}
	}
}

extension LoggedInTabBarController {
	private func didTapTapBarButton(_ button: TabBarButton) {
		guard self.selectedIndex != button.tag else {
			return
		}
		removeViewControllerFromParent(selectedIndex)
		attachViewControllerToParent(button.tag)
		
		self.selectedIndex = button.tag
	}
	
	private func removeViewControllerFromParent(_ index: Int) {
		tabBarButtons[index].isSelected = false
		
		let previousVC = tabViewControllers[index]
		previousVC.willMove(toParent: nil)
		previousVC.view.removeFromSuperview()
		previousVC.removeFromParent()
	}
	
	private func attachViewControllerToParent(_ index: Int) {
		let viewController = tabViewControllers[index]
		
		tabBarButtons[index].isSelected = true
		viewController.view.frame = view.frame
		viewController.didMove(toParent: self)
		self.addChild(viewController)
		self.view.addSubview(viewController.view)
		self.view.bringSubviewToFront(floatingTabBar)
	}
}

extension LoggedInTabBarController: FloatingTabBarPresentable {
	public func dismissTabBar() {
		UIView.animate(
			withDuration: 0.3,
			delay: 0,
			options: .curveLinear
		) { [weak self] in
			guard let self = self else { return }
			
			// TODO: SnapKit 이후 수정.
			self.floatingTabBar.frame = CGRect(
				x: self.floatingTabBar.frame.origin.x,
				y: self.view.frame.height + 100,
				width: self.floatingTabBar.frame.width,
				height: self.floatingTabBar.frame.height
			)
			self.view.layoutIfNeeded()
			}
	}
	
	public func presentTabBar() {
		UIView.animate(
			withDuration: 0.3,
			delay: 0,
			options: .curveLinear
		) { [weak self] in
			guard let self = self else { return }
			
			// TODO: SnapKit 이후 수정.
			self.floatingTabBar.frame = CGRect(
				x: self.floatingTabBar.frame.origin.x,
				y: self.view.frame.height - 92,
				width: self.floatingTabBar.frame.width,
				height: self.floatingTabBar.frame.height
			)
			self.view.layoutIfNeeded()
			}
	}
}
