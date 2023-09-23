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
	// MARK: - Properties
	weak var listener: LoggedInPresentableListener?
	private let disposeBag = DisposeBag()
	
	private var selectedIndex: Int = 0
	private lazy var tabBarButtons = [firstTabButton, secondTabButton, thirdTabButton]
	private var tabViewControllers = [UIViewController]()
	
	// MARK: - UI Components
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
	
	// MARK: - Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupUI()
		attachViewControllerToParent(at: 0)
	}
	
	// MARK: - setViewControllers
	func setViewControllers(_ viewControllers: [ViewControllable]) {
		viewControllers
			.map(\.uiviewController)
			.forEach { [weak self] viewController in
				self?.tabViewControllers.append(viewController)
			}
	}
}

// MARK: - UI Methods
private extension LoggedInTabBarController {
	func setupUI() {
		view.backgroundColor = .white

		setViewHierarchy()
		setConstraints()
		bind()
	}
	
	func setViewHierarchy() {
		view.addSubview(floatingTabBar)
		floatingTabBar.addSubviews(firstTabButton, secondTabButton, thirdTabButton)
	}
	
	func setConstraints() {
		floatingTabBar.snp.makeConstraints { make in
			make.leading.equalTo(view.snp.leading).offset(21)
			make.trailing.equalTo(view.snp.trailing).offset(-21)
			make.bottom.equalTo(view.snp.bottom).offset(-32)
			make.height.equalTo(60)
		}
		
		firstTabButton.snp.makeConstraints { make in
			make.leading.equalTo(floatingTabBar.snp.leading).offset(20)
			make.centerY.equalTo(floatingTabBar.snp.centerY)
		}
		
		secondTabButton.snp.makeConstraints { make in
			make.centerX.equalTo(floatingTabBar.snp.centerX)
			make.bottom.equalTo(firstTabButton.snp.bottom)
		}
		
		thirdTabButton.snp.makeConstraints { make in
			make.trailing.equalTo(floatingTabBar.snp.trailing).offset(-20)
			make.centerY.equalTo(floatingTabBar.snp.centerY)
		}
	}
}

// MARK: - Bind Method
private extension LoggedInTabBarController {
	func bind() {
		tabBarButtons.forEach { button in
			button.rx.tapGesture()
				.when(.recognized)
				.bind(with: self) { owner, _ in
					owner.didTapTapBarButton(at: button.tag)
				}
				.disposed(by: disposeBag)
		}
	}
}

// MARK: - TabBar Logic
private extension LoggedInTabBarController {
	func didTapTapBarButton(at index: Int) {
		guard self.selectedIndex != index else {
			return
		}
		removeViewControllerFromParent(at: selectedIndex)
		attachViewControllerToParent(at: index)
		
		self.selectedIndex = index
	}
	
	func removeViewControllerFromParent(at index: Int) {
		tabBarButtons[index].isSelected = false
		
		let previousVC = tabViewControllers[index]
		previousVC.willMove(toParent: nil)
		previousVC.view.removeFromSuperview()
		previousVC.removeFromParent()
	}
	
	func attachViewControllerToParent(at index: Int) {
		let viewController = tabViewControllers[index]
		
		tabBarButtons[index].isSelected = true
		viewController.view.frame = view.frame
		viewController.didMove(toParent: self)
		self.addChild(viewController)
		self.view.addSubview(viewController.view)
		self.view.bringSubviewToFront(floatingTabBar)
	}
}

// MARK: - FloatingTabBarPresentable
extension LoggedInTabBarController: FloatingTabBarPresentable {
	public func dismissTabBar() {
		UIView.animate(
			withDuration: 0.2,
			delay: 0,
			options: .curveLinear
		) { [weak self] in
			guard let self = self else { return }
			
			self.floatingTabBar.snp.updateConstraints { make in
				make.bottom.equalTo(self.view.snp.bottom).offset(100)
			}
			self.view.layoutIfNeeded()
		}
	}
	
	public func presentTabBar() {
		UIView.animate(
			withDuration: 0.2,
			delay: 0,
			options: .curveLinear
		) { [weak self] in
			guard let self = self else { return }

			self.floatingTabBar.snp.updateConstraints { make in
				make.bottom.equalTo(self.view.snp.bottom).offset(-32)
			}
			self.view.layoutIfNeeded()
		}
	}
}
