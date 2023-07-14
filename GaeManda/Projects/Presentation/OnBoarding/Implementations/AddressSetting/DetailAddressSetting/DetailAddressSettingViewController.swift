//
//  DetailAddressSettingViewController.swift
//  OnBoarding
//
//  Created by jung on 2023/07/08.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import RIBs
import RxSwift
import RxCocoa
import GMDExtensions
import GMDUtils

protocol DetailAddressSettingPresentableListener: AnyObject {
	func detailAddressSettingDidDismiss()
	func closeButtonDidTap()
	func loadLocationButtonDidTap()
}

final class DetailAddressSettingViewController:
	UIViewController,
	DetailAddressSettingPresentable,
	DetailAddressSettingViewControllable {	
	weak var listener: DetailAddressSettingPresentableListener?
	private let disposeBag = DisposeBag()
	
	private let topStackView: UIStackView = {
		let stackView = UIStackView()
		
		return stackView
	}()
	
	private let textField: UITextField = {
		let textField = UITextField()
		textField.translatesAutoresizingMaskIntoConstraints = false
		textField.placeholder = "지번, 도로명, 건물명으로 검색"
		textField.layer.cornerRadius = 7
		textField.layer.borderWidth = 1.2
		textField.layer.borderColor = UIColor.black.cgColor
		let image = UIImage(
			systemName: "magnifyingglass",
			withConfiguration: UIImage.SymbolConfiguration(weight: .bold)
		)
		textField.setLeftImage(image, size: 15, leftPadding: 8)
		
		return textField
	}()
	
	private let loadLocationButton: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		
		var configuration = UIButton.Configuration.plain()
		
		let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 12, weight: .light)
		let image = UIImage(
			systemName: "location.north.circle.fill",
			withConfiguration: imageConfiguration
		)
		configuration.image = image
		configuration.imagePadding = 10
		
		var titleAttribute = AttributedString.init("현재 위치로 설정")
		titleAttribute.font = .boldSystemFont(ofSize: 12)
		configuration.attributedTitle = titleAttribute
		
		configuration.contentInsets = NSDirectionalEdgeInsets(
			top: 4,
			leading: 0,
			bottom: 4,
			trailing: 0
		)
		configuration.background.backgroundColor = .black
		
		button.configuration = configuration
		button.tintColor = .white
		button.layer.cornerRadius = 4
		
		return button
	}()
	
	private let bottomView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = .init(hexCode: "#F6F6F6")
		
		return view
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
	}
	
	private func setupUI() {
		view.backgroundColor = .white
		title = "주소 검색"
		setupCloseNavigationButton(
			target: self,
			action: #selector(closeButtonDidTap)
		)
		
		setupSubviews()
		setConstraints()
		bind()
	}
	
	private func setupSubviews() {
		view.addSubview(textField)
		view.addSubview(loadLocationButton)
		view.addSubview(bottomView)
	}
	
	private func setConstraints() {
		let safeArea = view.safeAreaLayoutGuide
		NSLayoutConstraint.activate([
			textField.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 0),
			textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
			textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
			textField.heightAnchor.constraint(equalToConstant: 33),
			
			loadLocationButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20),
			loadLocationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
			loadLocationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
			loadLocationButton.heightAnchor.constraint(equalToConstant: 26),
			
			bottomView.topAnchor.constraint(equalTo: loadLocationButton.bottomAnchor, constant: 36),
			bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
	}
	
	private func bind() {
		self.rx.viewDidDisappear
			.withUnretained(self)
			.subscribe(
				onNext: { owner, _ in
					owner.listener?.detailAddressSettingDidDismiss()
				}
			)
			.disposed(by: disposeBag)
		
		loadLocationButton.rx.tap
			.withUnretained(self)
			.bind { owner, _ in
				owner.listener?.loadLocationButtonDidTap()
			}
			.disposed(by: disposeBag)
	}
}

// MARK: Action
extension DetailAddressSettingViewController {
	@objc func closeButtonDidTap() {
		listener?.closeButtonDidTap()
	}
}
